FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 443

RUN mkdir -p /var/www/html && \
    mkdir -p /etc/nginx/ssl && \
    chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

RUN openssl req -batch -x509 -sha256 -nodes -newkey rsa:2048 \
    -days 365 \
    -keyout /etc/ssl/private/private.key \
    -out /etc/ssl/certs/certificate.crt \
    -subj "/C=BR/ST=SP/L=Sao Paulo/O=42sp/CN=asanni.42.fr"

# CERT PERMISSIONS (CORRECT)
RUN chmod 600 /etc/ssl/private/private.key && \
    chmod 644 /etc/ssl/certs/certificate.crt

CMD ["nginx", "-g", "daemon off;"]
