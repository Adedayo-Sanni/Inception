#!/bin/bash

set -e

WP_PATH="/var/www/html"

echo "==> Iniciando WordPress entrypoint..."

# -------------------------------
# AGUARDAR MARIADB
# -------------------------------
echo "==> Aguardando MariaDB..."
while ! mariadb -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" &>/dev/null; do
    sleep 1
done
echo "==> MariaDB pronto."

# -------------------------------
# INSTALAR WP-CLI (se não existir)
# -------------------------------
if [ ! -f /usr/local/bin/wp ]; then
    echo "==> Instalando WP-CLI..."
fi

# -------------------------------
# AJUSTAR PERMISSÕES DO VOLUME
# -------------------------------
#echo "==> Ajustando permissões..."
#chown -R www-data:www-data "$WP_PATH"
#chmod -R 775 "$WP_PATH"

# -------------------------------
# INSTALAR WORDPRESS SE NECESSÁRIO
# -------------------------------
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "==> Baixando WordPress..."
    echo "==> Criando wp-config.php..."
    wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --path="$WP_PATH"

    echo "==> Instalando WordPress..."
    wp core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="$WP_PATH"
else
    echo "==> WordPress já instalado. Pulando configuração."
fi

echo "==> WordPress pronto. Iniciando PHP-FPM..."
exec "$@"
