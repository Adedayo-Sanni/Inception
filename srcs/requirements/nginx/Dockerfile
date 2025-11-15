FROM debian:bookworm

# Atualiza os pacotes e instala o Nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Expõe a porta padrão do NGINX
EXPOSE 80

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
