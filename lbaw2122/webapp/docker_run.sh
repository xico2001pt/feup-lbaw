#!/bin/bash
set -e

cd /var/www; php artisan config:cache
env >> /var/www/.env
php-fpm8.0 -D
nginx -g "daemon off;"
