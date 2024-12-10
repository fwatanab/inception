FROM debian:buster

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -fr /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# MariaDB設定ファイルをコピー
COPY conf/my.cnf /etc/mysql/my.cnf

# スクリプトをコンテナ内にコピー
COPY tools/startup.sh /usr/local/bin/startup.sh

# スクリプトに実行権限を付与
RUN chmod +x /usr/local/bin/startup.sh

# MariaDBのデフォルトポート
EXPOSE 3306

# スクリプトをエントリポイントとして設定
ENTRYPOINT ["/usr/local/bin/startup.sh"]

CMD ["mysqld"]
