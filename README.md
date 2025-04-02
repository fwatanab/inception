# Inception

## 概要
Inceptionは、仮想マシン内でDockerを用いて複数のサービスを仮想化する42Tokyoのシステム管理プロジェクトです。Docker Composeを使用して、インフラ全体を自動的にセットアップします。

## 要件
- Virtual Machine環境で実行
- DockerとDocker Composeのインストールが必要
- 各サービスは専用のコンテナで実行
- Dockerfileを自作し、イメージをビルド
- TLSv1.2またはTLSv1.3のNGINXコンテナを設定
- WordPress + php-fpm（NGINXなし）
- MariaDBコンテナ（NGINXなし）
- Dockerネットワークを使用し、コンテナ間を接続

## セットアップ
1. リポジトリをクローン
```bash
git clone https://github.com/fwatanab/inception.git
cd inception
```
2. 環境変数を設定
`srcs/.env` ファイルで設定をカスタマイズ
```env
DOMAIN_NAME=domain_name
VOLUME_DIR=/home/domain_name/data/

MYSQL_HOST=mariadb
MYSQL_DATABASE=wp_database

MYSQL_ROOT_PASSWORD=root_password
MYSQL_USER=user
MYSQL_PASSWORD=user_password

WP_TITLE=inception
WP_ADMIN_USER=wp_master
WP_ADMIN_PASSWORD=wp_admin_password
WP_ADMIN_EMAIL=wp@admin.com

WP_USER=wp_user
WP_USER_PASSWORD=wp_user_password
WP_USER_EMAIL=wp@user.com
WP_USER_ROLE=subscriber
```
3. コンテナをビルドして起動
```bash
make
```
4. ブラウザからアクセス
https://domain_name

## プロジェクト構成
- `srcs/` - プロジェクトの設定ファイルを配置
- `srcs/requirements` - 各サービスごとの設定
- `docker-compose.yml` - サービスの定義

## 注意事項
- 環境変数や認証情報は `.env` ファイルに保存し、Git管理対象から除外
- 無限ループを避けるため `tail -f` や `sleep infinity` は使用禁止

## ライセンス
このプロジェクトは42Tokyoの課題です。

