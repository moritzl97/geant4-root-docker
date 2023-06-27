#!/bin/bash
echo "=> Building docker"
docker build \
    -t $IMAGE_NAME .
