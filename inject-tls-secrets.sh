#!/bin/bash
# Extracts a subset of TLS secrets and injects them in an existing capture file.
#
# Author: Peter Wu <peter@lekensteyn.nl>

set -eu

if [ $# -lt 2 ]; then
    echo "Usage: $0 keylog.txt some.pcapng [output.pcapng]"
    echo "Output file is based on input file (e.g. some-dsb.pcapng)."
    exit 1
fi

keys_file="$1"
capture_file="$2"
if [ ! -s "$keys_file" ]; then
    echo "Missing keys file"
    exit 1
fi
if [ ! -s "$capture_file" ]; then
    echo "Missing capture file"
    exit 1
fi

output_file="${3:-}"
if [ -z "$output_file" ]; then
    basename1="${capture_file%.*}"
    basename2="${basename1%.*}"
    case "$capture_file" in
    *.pcap|*.pcapng)
        output_file=$basename1-dsb.pcapng
        ;;
    *.pcap.gz|*.pcapng.gz)
        output_file=$basename2-dsb.pcapng
        ;;
    *)
        output_file=$capture_file-dsb.pcapng
        ;;
    esac
fi

explain_missing_sessions() {
    echo "Potential reasons for this:"
    echo " - TLS runs on a custom port. Use 'Decode As' 'TCP Port' -> TLS."
    echo " - The packet capture was started before keys were captured."
    echo " - The TLS handshake was not captured, try restarting the connection."
}

explain_missing_keys() {
    echo "Potential reasons for this:"
    echo " - The TLS handshake was not completed."
    echo " - Traffic goes through multiple hosts or programs and are"
    echo "   reencrypted (proxied), but keys are captured from the wrong one."
}

rands=$(tshark -Tfields -Ytls.handshake.type==1 -etls.handshake.random -r "$capture_file")
keys=$(xargs -n1 grep "$keys_file" -wiFe <<<"$rands") || :

# Assume client random to be unique. For TLS 1.3, multiple secrets will exist,
# so deduplicate those.
nrands=$(echo "$rands" | grep -c .) || :
nkeys=$(echo "$keys" | grep -c .) || :
nkeys_unique=$(echo "$keys" | sort -uk2,2 | grep -c .) || :
if [ $nrands -eq 0 ]; then
    echo "No TLS sessions found"
    explain_missing_sessions
    exit 1
elif [ $nkeys -eq 0 ]; then
    echo "No secrets found for $nrands sessions."
    explain_missing_keys
    exit 1
elif [ $nrands -gt $nkeys_unique ]; then
    echo "Note: found keys for $nkeys_unique sessions, but there are more sessions in total ($nrands)"
    explain_missing_keys
    echo "Continuing anyway, but some sessions might fail to be decrypted."
    #exit 1
elif [ $nrands -lt $nkeys_unique ]; then
    echo "Note: found keys for $nkeys_unique sessions, but there are less sessions in total ($nrands)"
    explain_missing_sessions
fi

tmp1=
tmp2=
trap 'rm -f "$tmp1" "$tmp2"' EXIT
tmp1=$(mktemp)
tmp2=$(mktemp)
echo "$keys" > "$tmp1"

# Replace existing secrets with the subset.
editcap --discard-all-secrets --inject-secrets tls,"$tmp1" "$capture_file" "$tmp2"
mv "$tmp2" "$output_file"

echo "Injected $nkeys secret(s) for $nkeys_unique session(s) in $output_file"
