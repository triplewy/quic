#!/bin/bash

docker stop httpd
docker rm httpd
docker run \
-dit \
-p 4433:443 \
-v $HOME/quic/www:/usr/local/apache2/htdocs/ \
-v $HOME/quic/certs/leaf_cert.key:/usr/local/apache2/conf/server.key \
-v $HOME/quic/certs/leaf_cert.pem:/usr/local/apache2/conf/server.pem \
--name httpd \
httpd:h2

docker logs -f httpd