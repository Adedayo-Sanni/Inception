#!/bin/bash

set -e

echo marcelo_eh_fodao > marcelo2

# Diretório de dados
if [ ! -f /var/lib/mysql/.initialized ]; then
    echo "🔧 Inicializando banco pela primeira vez..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
    echo marcelo_eh_fodao > marcelo
    # Arquivo temporário com as queries de inicialização
    TEMP_FILE=/tmp/init.sql

#     cat << EOF > $TEMP_FILE
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

# CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';
# GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;

# CREATE USER IF NOT EXISTS '${WP_ADMIN}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';
# GRANT ALL PRIVILEGES ON *.* TO '${WP_ADMIN}'@'%' WITH GRANT OPTION;

# FLUSH PRIVILEGES;
# EOF
    service mariadb start

    sleep 5

    echo "🔧 Criando database e usuários..."

    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS '${WP_ADMIN}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${WP_ADMIN}'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

    touch /var/lib/mysql/.initialized
    service mariadb stop

    # mysqld --bootstrap < $TEMP_FILE
    # rm -f $TEMP_FILE
fi

echo "🚀 Iniciando MariaDB..."
# exec mysqld
exec mysqld_safe
