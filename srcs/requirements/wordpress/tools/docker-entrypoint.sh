#!/bin/bash

# エラー時にスクリプトを停止
set -e

echo "Starting WordPress setup..."

# 必要な環境変数を確認
if [ -z "$WORDPRESS_DB_HOST" ] || [ -z "$WORDPRESS_DB_USER" ] || [ -z "$WORDPRESS_DB_PASSWORD" ] || [ -z "$WORDPRESS_DB_NAME" ]; then
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
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USER/" wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" wp-config.php
fi

echo "WordPress setup completed."

# PHP-FPMを起動
exec php-fpm7.3 -F

