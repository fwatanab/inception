#!/bin/bash

# エラー時にスクリプトを停止
set -e

echo "Starting WordPress setup..."

# 必要な環境変数を確認
if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ]; then
    echo "Error: Missing required environment variables." >&2
    exit 1
fi

# WordPressが未インストールの場合にインストール
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress..."
    wget https://wordpress.org/latest.tar.gz -O wordpress.tar.gz
    tar -xzf wordpress.tar.gz --strip-components=1
    rm wordpress.tar.gz

    echo "Configuring WordPress..."
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$MYSQL_NAME/" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/" wp-config.php
fi

echo "WordPress setup completed."

# PHP-FPMを起動
exec php-fpm7.3 -F

