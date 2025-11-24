#!/bin/bash

set -e

# Diretório WP
WP_PATH="/var/www/html"

# Apenas para debug inicial:
echo "Iniciando WordPress entrypoint..."

# Espera o MariaDB estar pronto
echo "Aguardando MariaDB..."
while ! mariadb -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" &> /dev/null; do
    sleep 1
done
echo "MariaDB pronto."

# Instalar WP-CLI caso não exista
if [ ! -f /usr/local/bin/wp ]; then
    echo "Instalando WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Baixar WordPress apenas se não existir
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Baixando WordPress..."
    wp core download --allow-root --path="$WP_PATH"

    echo "Criando wp-config.php..."
    wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --path="$WP_PATH"

    echo "Instalando WordPress..."
    wp core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="$WP_PATH"
else
    echo "WordPress já instalado, pulando configuração."
fi

echo "WordPress pronto. Iniciando PHP-FPM..."
exec "$@"