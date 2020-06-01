#!/usr/bin/env bash
PORT=$1

/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary \
--user-data-dir=/tmp/chrome-profile \
--enable-quic \
--quic-version=h3-27 \
--allow-insecure-localhost \
--origin-to-force-quic-on=127.0.0.1:$PORT \
--disk-cache-dir=/dev/null \
--disk-cache-size=1 \
https://127.0.0.1:$PORT/10kb/index-100.html