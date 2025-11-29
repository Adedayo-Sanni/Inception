FROM debian:bookworm

WORKDIR /var/www/html

# Atualização e instalação de dependências
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-cli \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    wget \
    curl \
    mariadb-client \
    vim \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------------
# INSTALAR WP-CLI 
# -------------------------------------
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# -------------------------------------
# BAIXAR WORDPRESS
# -------------------------------------
RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz -C /tmp && \
    #rm -rf /var/www/html/* && \
    #mv /tmp/wordpress/* /var/www/html 
    # o que tava antes
    mv /tmp/wordpress /usr/src/wordpress


RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Copia configuração do PHP-FPM
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copia entrypoint
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
