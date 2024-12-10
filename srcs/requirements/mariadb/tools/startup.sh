#!/bin/bash

# MariaDBの初期設定スクリプト
set -e

# データディレクトリの初期化
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB data directory is empty. Initializing..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Configuring MariaDB..."
    cat <<EOF > /tmp/init.sql
USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    # bootstrapで初期設定
    mysqld --user=mysql --bootstrap < /tmp/init.sql

    rm -f /tmp/init.sql

    echo "MariaDB configuration completed." 
else
    echo "MariaDB data directory already exists. Skipping initialization."
fi

echo "Starting MariaDB server..."

# MariaDBを起動
exec mysqld --user=mysql --datadir=/var/lib/mysql
