FROM debian:buster

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
    && rm -fr /var/lib/apt/lists/*

COPY tools/startup.sh /usr/local/bin/startup.sh

RUN chmod +x /usr/local/bin/startup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/startup.sh"]
