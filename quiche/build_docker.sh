#!/usr/bin/env bash

docker stop quiche
docker rm quiche
docker build . -t quiche