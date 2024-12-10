FROM debian:buster

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

# WordPressのセットアップ用ディレクトリを作成
WORKDIR /var/www/html

# WordPressのインストールスクリプトをコピー
COPY tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# スクリプトに実行権限を付与
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# PHP-FPMの設定をカスタマイズ
COPY conf/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf

# 初期化スクリプトを実行
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
