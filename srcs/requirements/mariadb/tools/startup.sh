#!/bin/bash

# MariaDBの初期設定スクリプト
set -e

# MariaDBデータディレクトリの初期化
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB data directory is empty. Initializing..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Configuring MariaDB..."
    cat <<EOF > /tmp/init.txt
USE mysql;

-- すべてのrootユーザーの削除
DELETE FROM mysql.user WHERE user='root';

-- 初期化と権限設定のリフレッシュ
FLUSH PRIVILEGES;

-- rootユーザーの設定（ローカル＆リモート）
CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- WordPress用データベースとユーザーの設定
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
ALTER USER \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';

-- 匿名ユーザーの削除
DELETE FROM mysql.user WHERE user = '';

-- 最終権限反映
FLUSH PRIVILEGES;
EOF

    # bootstrapで初期設定
    mysqld --user=mysql --bootstrap < /tmp/init.txt || {
        echo "Error: MariaDB initialization failed." >&2
        exit 1
    }

    rm -f /tmp/init.txt
    echo "MariaDB configuration completed."
else
    echo "MariaDB data directory already exists. Skipping initialization."
fi

echo "Starting MariaDB server..."

# MariaDBを起動
exec mysqld --user=mysql --datadir=/var/lib/mysql
