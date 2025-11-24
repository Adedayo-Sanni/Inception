#!/bin/bash

set -e

# Diretório de dados
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🔧 Inicializando banco pela primeira vez..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql

    # Arquivo temporário com as queries de inicialização
    TEMP_FILE=/tmp/init.sql

    cat << EOF > $TEMP_FILE
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

    mysqld --bootstrap < $TEMP_FILE
    rm -f $TEMP_FILE
fi

echo "🚀 Iniciando MariaDB..."
exec mysqld