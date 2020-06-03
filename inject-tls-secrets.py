#!/usr/bin/env python3
# Extracts a subset of TLS secrets and injects them in an existing capture file.
#
# Author: Peter Wu <peter@lekensteyn.nl>

import argparse
import os
import shlex
import subprocess
import sys
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument('--debug', action='store_true',
                    help='Print tshark and editcap commands')
parser.add_argument('-d', dest='decode_as', default=[], action='append',
                    help='Decode As options for tshark, e.g. -dudp.port==443,quic')
parser.add_argument('-o', dest='prefs', default=[], action='append',
                    metavar='preference_setting',
                    help='Preferences for tshark, e.g. -otcp.reassemble_out_of_order:TRUE')
parser.add_argument('secrets_file', metavar='keylog.txt',
                    help='File with TLS decryption secrets (from SSLKEYLOGFILE)')
parser.add_argument('input_capture_file',
                    help='Input file, e.g. some.pcapng')
parser.add_argument('output_capture_file', nargs='?',
                    help='Output file. Defaults to a name based on the input file, e.g. some-dsb.pcapng')


def getsize(filename):
    try:
        return os.path.getsize(filename)
    except OSError:
        return 0


def remove_file(filename):
    try:
        if filename:
            os.remove(filename)
    except FileNotFoundError:
        pass


def make_output_file(capture_file):
    '''
    Given an input file some.pcap, some.pcapng, some.pcap.gz, or some.pcapng.gz,
    return some-dsb.pcapng. For other files, just append '-dsb.pcapng'.
    '''
    root, ext = os.path.splitext(capture_file)
    if ext == '.gz':
        root, ext = os.path.splitext(root)
    if ext in ('.pcap', '.pcapng'):
        return root + '-dsb.pcapng'
    return capture_file + '-dsb.pcapng'


def is_client_random(token):
    return len(token) == 64


def read_key_log_file(key_log_file):
    secrets = {}
    with open(key_log_file) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            try:
                label, client_random, secret = line.split(' ')
            except ValueError:
                continue
            print(label, client_random, secret)
            if not is_client_random(client_random):
                continue
            sub_keys = secrets.setdefault(client_random.lower(), [])
            if not line in sub_keys:
                sub_keys.append(line)
    return secrets


def extract_client_randoms(rands):
    valid_rands = []
    for rand in rands:
        # Duplicates may occur when running the Go test suite with fixed client
        # random values. This is not correctly handled by Wireshark, but at
        # least ensure that we do not include the same secrets multiple times.
        if is_client_random(rand) and rand not in valid_rands:
            valid_rands.append(rand)
    return valid_rands


def filter_keys(all_keys, client_randoms):
    keys = []
    nsessions = 0
    for client_random in client_randoms:
        if not client_random in all_keys:
            print("Warning: missing secrets for Client Random", client_random)
            continue
        nsessions += 1
        keys.extend(all_keys[client_random])
    return nsessions, keys


def explain_missing_sessions():
    print("""
Potential reasons for this:
 - TLS runs on a custom port. Use 'Decode As' 'TCP Port' -> TLS.
 - The packet capture was started before keys were captured.
 - The TLS handshake was not captured, try restarting the connection.
""".strip())


def explain_missing_keys():
    print("""
Potential reasons for this:
 - The TLS handshake was not completed.
 - Traffic goes through multiple hosts or programs and are
   reencrypted (proxied), but keys are captured from the wrong one.
""".strip())


def main():
    args = parser.parse_args()
    keys_file = args.secrets_file
    capture_file = args.input_capture_file
    output_file = args.output_capture_file or make_output_file(capture_file)
    extra_tshark_args = ['-d' + opt for opt in args.decode_as]
    extra_tshark_args += ['-o' + opt for opt in args.prefs]

    def debug_cmd(cmd):
        if args.debug:
            print(' '.join(shlex.quote(arg) for arg in cmd))

    if getsize(keys_file) == 0:
        print("Missing or empty keys file")
        return 1

    if getsize(capture_file) == 0:
        print("Missing or empty capture file")
        return 1

    # Scan for client randoms.
    cmd = ["tshark", "-Tfields", "-Ytls.handshake.type==1",
           "-etls.handshake.random", "-r", capture_file] + extra_tshark_args
    debug_cmd(cmd)
    rands = subprocess.check_output(cmd, universal_newlines=True).split()
    rands = extract_client_randoms(rands)

    # Assume client random to be unique. For TLS 1.3, multiple secrets will
    # exist, so extract secrets and group them per client random.
    all_keys = read_key_log_file(keys_file)
    nsessions, keys = filter_keys(all_keys, rands)

    if not rands:
        print("No TLS sessions found")
        explain_missing_sessions()
        return 1
    elif not keys:
        print("No secrets found for all %d sessions." % (len(rands)))
        explain_missing_keys()
        return 1
    elif len(rands) > nsessions:
        print("Note: found keys for %d sessions, but there are more sessions in total (%d)" % (
            nsessions, len(rands)))
        explain_missing_keys()
        print("Continuing anyway, but some sessions might fail to be decrypted.")
        # return 1
    elif len(rands) < nsessions:
        print("Note: found keys for %d sessions, but there are less sessions in total (%d)" % (
            nsessions, len(rands)))
        explain_missing_sessions()

    tmp = output_file + '.tmp'
    try:
        # Write secrets to a temporary file.
        tmp_secrets = tempfile.NamedTemporaryFile('w', delete=False)
        tmp_secrets.write('\n'.join(keys) + '\n')
        tmp_secrets.close()

        # Replace existing secrets with the subset.
        cmd = ["editcap", "--discard-all-secrets", "--inject-secrets",
               "tls," + tmp_secrets.name, capture_file, tmp]
        debug_cmd(cmd)
        subprocess.check_call(cmd)
        os.replace(tmp, output_file)
        print("Injected", len(keys), "secret(s) for", nsessions, "session(s) in",
              output_file)
    finally:
        remove_file(tmp_secrets.name)
        remove_file(tmp)


if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
    except subprocess.CalledProcessError as e:
        sys.exit(e.returncode)
