#!/bin/bash
set -e

# Inicia o serviço temporariamente para criar DB e usuários
service mysql start

# Se o banco ainda não existir, é primeira inicialização
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "🔧 Inicializando MariaDB pela primeira vez..."

    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

    # Cria o banco principal do WordPress
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

    # Usuário principal do WordPress
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    "

    # Admin adicional opcional
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "
        CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;
    "

    # Usuário espelho
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%';
    "

    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

echo "🚀 Iniciando MariaDB..."
mysqladmin --silent --wait=30 ping || exit 1

# Finaliza serviço temporário e entra no mysqld_safe
service mysql stop
exec "$@"
