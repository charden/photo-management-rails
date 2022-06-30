# 環境情報

- ruby: 3.1.2
- Node: 16.15.1
- Docker: 20.10.14
- Docker Compose: 2.4.1

# 実行方法

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

http://localhost:3000
