FROM debian:bookworm

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

# Diretório onde ficará o WordPress
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

# Copia configuração do PHP-FPM
COPY conf/www.conf /etc/php/*/fpm/pool.d/www.conf

# Copia entrypoint
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
