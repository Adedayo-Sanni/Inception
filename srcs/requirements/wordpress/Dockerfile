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

# se der errado, chmod na pasta
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --allow-root --path=/var/www/html

# Diretório onde ficará o WordPress
RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Copia configuração do PHP-FPM
COPY conf/www.conf /etc/php/*/fpm/pool.d/www.conf

# Copia entrypoint
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
