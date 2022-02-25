#!/bin/bash

# Stop execution if a step fails
set -e

IMAGE_NAME=git.fe.up.pt:5050/lbaw/lbaw2122/lbaw2122

# Ensure that dependencies are available
composer install
php artisan clear-compiled
php artisan optimize

docker build -t $IMAGE_NAME .
docker push $IMAGE_NAME
