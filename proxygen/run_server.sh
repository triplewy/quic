#!/usr/bin/env bash

# Extra debugging ?
set -x
set -o nounset

DRAFT=27
HQ_CLI=/hq
PORT=4433
LOGLEVEL=4
ROOT_DIR=/www
CERTS_DIR=/certs
QLOG_PATH=/qlog

# Unless noted otherwise, test cases use HTTP/0.9 for file transfers.
PROTOCOL="hq-${DRAFT}"
HTTPVERSION="3.0"

# Default enormous flow control.
CONN_FLOW_CONTROL="107374182" # 100mb
STREAM_FLOW_CONTROL="107374182" # 100mb
INVOCATIONS=$(echo ${REQUESTS} | tr " " "\n" | awk -F '/' '{ print "/" $4 }' | paste -sd',')
EARLYDATA="false"
PSK_FILE="" # in memory psk

echo "Running QUIC server on 0.0.0.0:${PORT}"
${HQ_CLI} \
--mode=server \
--port=${PORT} \
--httpversion=${HTTPVERSION} \
--h2port=${PORT} \
--static_root=${ROOT_DIR} \
--use_draft=true \
--draft-version=${DRAFT} \
--logdir=/logs \
--qlogger_path=${QLOG_PATH} \
--host=0.0.0.0 \
--conn_flow_control=${CONN_FLOW_CONTROL} \
--stream_flow_control=${STREAM_FLOW_CONTROL} \
--congestion=cubic \
--pacing=false \
--key=${CERTS_DIR}/leaf_cert.key \
--cert=${CERTS_DIR}/leaf_cert.pem \
--v=${LOGLEVEL} 2>&1 | tee /logs/server.log
