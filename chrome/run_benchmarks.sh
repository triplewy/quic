#!/bin/bash

SIZES="10kb 100kb"
NUM_OBJECTS="10 100"
SERVERS=(http2 proxygen quiche chromium)
PORTS=(30000 30001 30002 30003)

for SIZE in $SIZES
do
    for NUM_OBJECT in $NUM_OBJECTS
    do
        for i in ${!SERVERS[@]}
        do
            SERVER=${SERVERS[$i]}
            PORT=${PORTS[$i]}
            
            echo "SERVER: $SERVER, PORT: $PORT"
            
            # Make qlog dir
            QLOG_DIR=$HOME/quic/qlog/$SIZE/$NUM_OBJECT/$SERVER
            mkdir -p $QLOG_DIR
            
            # Start docker container
            sh ../$SERVER/run_docker.sh $QLOG_DIR $PORT
            
            # Start wireshark
            WIRESHARK_DIR=$HOME/quic/wireshark/$SIZE/$NUM_OBJECT/$SERVER
            mkdir -p $WIRESHARK_DIR
            
            tshark \
            -i lo0 \
            -f "tcp src port $PORT or tcp dst port $PORT or udp src port $PORT or udp dst port $PORT" \
            -a duration:5 \
            -a packets:20 \
            -w $WIRESHARK_DIR/capture.pcapng &
            
            sleep 1
            # Start chrome load page and fork wireshark capturing
            node index.js $SERVER $PORT $SIZE $NUM_OBJECT
        done
    done
done

python3 $HOME/quic/har-analyzer/main.py