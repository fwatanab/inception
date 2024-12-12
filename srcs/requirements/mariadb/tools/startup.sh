#!/bin/bash

# MariaDBの初期設定スクリプト
set -e

# データディレクトリの初期化
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB data directory is empty. Initializing..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Configuring MariaDB..."
    cat <<EOF > /tmp/init.txt
USE mysql;

-- 初期化と権限設定のリフレッシュ
FLUSH PRIVILEGES;

-- rootユーザーの設定
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY \'${MYSQL_ROOT_PASSWORD}\';
ALTER USER 'root'@'localhost' IDENTIFIED BY \'${MYSQL_ROOT_PASSWORD}\';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

-- fwatanabユーザーの設定
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS \'${MYSQL_USER}\'@'%' IDENTIFIED BY \'${MYSQL_PASSWORD}\';
CREATE USER IF NOT EXISTS \'${MYSQL_USER}\'@'localhost' IDENTIFIED BY \'${MYSQL_PASSWORD}\';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \'${MYSQL_USER}\'@'%';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \'${MYSQL_USER}\'@'localhost';

-- 匿名ユーザーの削除
DELETE FROM mysql.user WHERE user = '';

-- 最終権限反映
FLUSH PRIVILEGES;
EOF

    # bootstrapで初期設定
    mysqld --user=mysql --bootstrap < /tmp/init.txt

    rm -f /tmp/init.txt

    echo "MariaDB configuration completed." 
else
    echo "MariaDB data directory already exists. Skipping initialization."
fi

echo "Starting MariaDB server..."

# MariaDBを起動
exec mysqld --user=mysql --datadir=/var/lib/mysql
