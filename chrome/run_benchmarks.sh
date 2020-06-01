#!/bin/bash

# Start httpd docker
sh ../http2/run_docker.sh
# Start proxygen docker
sh ../proxygen/run_docker.sh
# Start quiche docker
sh ../quiche/run_docker.sh

# Start benchmarks
node index.js