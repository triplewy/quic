#!/bin/bash

for SIZE in 10kb 100kb 1000kb 10000kb
do
    mkdir -p www/$SIZE/images
    for i in {1..100}
    do
        echo "Copying $i / 100 images for size $SIZE"
        cp www/images/$SIZE.jpg www/$SIZE/images/$SIZE-$i.jpg
    done
done
