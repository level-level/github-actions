#!/bin/sh -l
echo "{\"http-basic\": {\"$SATIS_DOMAIN\": {\"username\": \"$SATIS_USERNAME\",\"password\": \"$SATIS_PASSWORD\"}}}" > auth.json
cat auth.json
composer install --ignore-platform-reqs --prefer-dist  --no-suggest --no-progress
composer run test