FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    php-curl \
    php-xml \
    php-mbstring \
    mariadb-client \
    curl \
    wget \
    unzip \
    tar \
    vim \
    && rm -fr /var/lib/apt/lists/*

# WP-CLIのインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# WordPressのセットアップ用ディレクトリを作成
WORKDIR /var/www/html

# WordPressのインストールスクリプトをコピー
COPY tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# スクリプトに実行権限を付与
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# PHP-FPMの設定をカスタマイズ
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

EXPOSE 9000

# 初期化スクリプトを実行
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
