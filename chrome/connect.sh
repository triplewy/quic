#!/usr/bin/env bash

/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary \
--user-data-dir=/tmp/chrome-profile \
--enable-quic \
--quic-version=h3-27 \
--allow-insecure-localhost \
--origin-to-force-quic-on=127.0.0.1:4433 \
https://127.0.0.1:4433/