#!/bin/bash

# my.cnf を動的に作成
echo "[client]" > /etc/mysql/my.cnf
echo "user=root" >> /etc/mysql/my.cnf
echo "password=$MYSQL_ROOT_PASSWORD" >> /etc/mysql/my.cnf
chmod 600 /etc/mysql/my.cnf

# # MySQLデーモンをフォアグラウンドで直接起動
# mysqld --datadir=/var/lib/mysql --user=mysql --console

# MySQLデーモンをバックグラウンドで起動
mysqld_safe &

# MySQLが起動するまで待機
while ! mysqladmin ping --silent; do
    sleep 1
done

# データベースの作成
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

# ユーザー権限の設定
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';"

# 権限変更を適用
mysql -e "FLUSH PRIVILEGES;"

# コンテナを正常に保持
wait $!
