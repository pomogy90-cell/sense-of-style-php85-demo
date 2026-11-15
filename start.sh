#!/bin/sh
set -eu

LISTEN_PORT="${PORT:-3000}"
sed -ri "s/^Listen [0-9]+$/Listen ${LISTEN_PORT}/" /etc/apache2/ports.conf
sed -ri "s/<VirtualHost \\*:[0-9]+>/<VirtualHost *:${LISTEN_PORT}>/" /etc/apache2/sites-available/000-default.conf

if [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
    export APP_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

exec apache2-foreground
