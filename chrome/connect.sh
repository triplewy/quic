#!/usr/bin/env bash
PORT=$1

/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary \
--user-data-dir=/tmp/chrome-profile \
--enable-quic \
--quic-version=h3-27 \
--allow-insecure-localhost \
--origin-to-force-quic-on=127.0.0.1:$PORT \
https://127.0.0.1:$PORT/10kb/index-10.html