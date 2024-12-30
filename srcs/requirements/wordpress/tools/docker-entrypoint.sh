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
    sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/" wp-config.php

    echo "Installing WordPress via WP-CLI..."
    wp core install \
      --allow-root \
      --url="https://$DOMAIN_NAME" \
      --title="$WP_TITLE" \
      --admin_user="$WP_ADMIN_USER" \
      --admin_password="$WP_ADMIN_PASSWORD" \
      --admin_email="$WP_ADMIN_EMAIL" \
      --skip-email

    echo "Creating an additional user via WP-CLI..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --role="$WP_USER_ROLE" --allow-root

    echo "WordPress installation and user creation completed via WP-CLI."
fi

echo "WordPress setup completed."

# PHP-FPMを起動
exec php-fpm7.4 -F
