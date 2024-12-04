FROM debian:buster

RUN apt-get update && apt-get install -y wordpress \
    && rm -fr /var/lib/apt/lists/*

CMD ["wordpress", "-g", "daemon off;"]
