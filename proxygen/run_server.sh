#!/usr/bin/env bash

# Extra debugging ?
set -x
set -o nounset

DRAFT=28
HQ_CLI=/hq
PORT=443
LOGLEVEL=4

# Unless noted otherwise, test cases use HTTP/0.9 for file transfers.
PROTOCOL="hq-${DRAFT}"
HTTPVERSION="3.0"

# Default enormous flow control.
CONN_FLOW_CONTROL="107374182"
STREAM_FLOW_CONTROL="107374182"
INVOCATIONS=$(echo ${REQUESTS} | tr " " "\n" | awk -F '/' '{ print "/" $4 }' | paste -sd',')
EARLYDATA="false"
PSK_FILE="" # in memory psk

echo "Running QUIC server on 0.0.0.0:${PORT}"
${HQ_CLI} \
--mode=server \
--port=${PORT} \
--httpversion=${HTTPVERSION} \
--h2port=${PORT} \
--static_root=/www \
--use_draft=true \
--draft-version=${DRAFT} \
--logdir=/logs \
--qlogger_path=/logs \
--host=127.0.0.1 \
--congestion=cubic \
--pacing=true \
--v=${LOGLEVEL} 2>&1 | tee /logs/server.log
