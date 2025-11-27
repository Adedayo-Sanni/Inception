FROM debian:bookworm

# Atualiza e instala MariaDB server
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Copia configuração e scripts
COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/setup-db.sh /usr/local/bin/setup-db.sh

# Permissões
RUN chmod +x /usr/local/bin/setup-db.sh

# Expor porta interna (WordPress acessa via rede, não via host)
EXPOSE 3306

# Data directory será um volume bind-mount
VOLUME ["/var/lib/mysql"]

# Comando principal (PID 1 real)
ENTRYPOINT ["/usr/local/bin/setup-db.sh"]
