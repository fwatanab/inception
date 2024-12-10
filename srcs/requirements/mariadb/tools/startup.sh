#!/bin/bash

# MariaDBの初期設定スクリプト
set -e

# ログ出力設定
LOG_FILE="/var/log/mariadb-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting MariaDB initialization script..."

# 必須の環境変数を確認
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ]; then
    echo "Error: Required environment variables are not set." >&2
    echo "Environment variables: MYSQL_ROOT_PASSWORD, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE" >&2
    exit 1
fi

echo "Environment variables are properly set."

# MariaDBを一時的に起動
mysqld_safe --skip-networking --user=mysql &
sleep 5

# MariaDBの状態を確認
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping --silent; do
    sleep 2
done

# # データディレクトリの初期化
# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     echo "MariaDB data directory is empty. Initializing..."
#     mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
# else
#     echo "MariaDB data directory already exists. Skipping initialization."
# fi
# 
# # MariaDBを起動して初期設定を実行
# echo "Starting temporary MariaDB server for initialization..."
# mysqld_safe --skip-networking --user=mysql &
# sleep 5

echo "Configuring MariaDB..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "MariaDB configuration completed. Shutting down temporary server..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# 正常なMariaDB起動
echo "Starting MariaDB server..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
