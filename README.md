# 環境情報

- ruby: 3.1.2
- Node: 16.15.1
- Docker: 20.10.14
- Docker Compose: 2.4.1

# 実行方法

## 環境変数の設定

.envを作成する
```bash
cp .env.sample .env
```

事前に頂いているアカウント情報を.envに設定する

- TWEET_APP_AUTH_URL
  - PDFに記載の herokuapp.com のURLを設定
  - (例: https://**.herokuapp.com)
- TWEET_APP_AUTH_CLIENT_ID
  - 事前に頂いているclient_id
- TWEET_APP_AUTH_CLIENT_SECRET
  - 事前に頂いているclient_secret

## makeコマンドが使える場合

### 環境のセットアップ
- Dockerfileのビルド
- ライブラリのインストール
- DBの作成、Seedの追加

```bash
make setup
```

### Railsの起動

```bash
make start
```

## dockerで個別で行う場合


### 環境のセットアップ

#### Dockerfileのビルド
```bash
docker compose build
```

#### ライブラリのインストール
```bash
docker compose run --rm web bundle install
```

#### DBの作成
```bash
docker compose run --rm web bundle exec rails db:create
```

#### DBのマイグレーション
```bash
docker compose run --rm web bundle exec rails db:migrate
```


#### DBのSeedの挿入
```bash
docker compose run --rm web bundle exec rails db:seed
```

### Railsの起動

```bash
docker compose up
```

# ローカルでのアクセス

## URL

http://localhost:3000

## ログイン情報
- ユーザーID
  - test
- パスワード
  - password

db/seed.rbにて作成

# Gemの追加

- minitestで利用するため以下のGemを追加している
  - https://github.com/bblimke/webmock
