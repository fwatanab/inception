FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    curl \
    && rm -fr /var/lib/apt/lists/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/CN=${DOMAIN_NAME}"


RUN rm -f /etc/nginx/sites-enabled/default || true

COPY conf/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
