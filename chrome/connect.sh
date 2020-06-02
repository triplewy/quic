#!/usr/bin/env bash
PORT=$1

/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary \
--user-data-dir=/tmp/chrome-profile \
--enable-quic \
--quic-version=h3-27 \
--allow-insecure-localhost \
--disk-cache-dir=/dev/null \
--disk-cache-size=1 \
--origin-to-force-quic-on=www.example.org:443 \
--host-resolver-rules="MAP www.example.org:443 127.0.0.1:$PORT" \
https://www.example.org/10kb/index-10.html