#!/bin/bash

HOME=/home/ayu9
cd $HOME/chromium/src/out/Debug
rm -rf libs
mkdir -p libs
for FILE in $(ldd quic_server | grep "=> /" | awk '{print $3}')
do
    FILENAME=$(echo $FILE | awk -F/ '{print $NF}')
    echo "Copying $FILENAME to libs/"
    sudo cp $FILE $HOME/chromium/src/out/Debug/libs/$FILENAME
done
tar cvf libs.tar libs