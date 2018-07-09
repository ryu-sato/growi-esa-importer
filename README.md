# growi-importer-esa とは

esa のデータを一時的に DB にインポートして GROWI(crowi) へアップロードするアプリケーションです。

Rake コマンドによりバッチ処理を行うことが出来ます。
また、データを操作する簡易 UI を使うことも出来ます。

# 使い方

## 実行環境の構築

### Ruby のインストール

[rbenv](https://github.com/rbenv/rbenv) 等を使って適宜。

### JavaScript 実行環境のインストール

Node 等を適宜インストール。

## 設定

アプリケーション実行時の環境変数により設定が出来ます。
簡易UIから設定する場合はメニューバーから設定ボタン（ギアマーク）を押下して表示される画面から設定して下さい。

|環境変数名|簡易UI項目名|説明|備考|
| --- | --- | --- | --- |
|CROWI_URL|Crowi url|Crowi(GROWI) の URL|crowi-client の仕様により Basic 認証が設定されていると動作しません|
|CROWI_ACCESS_TOKEN|Crowi access token|Crowi(GROWI) の Access Token||
|ESA_ACCESS_TOKEN|Esa access token|esa の Access Token|Read 権限が必要です|
|ESA_CURRENT_TEAM|Esa team|esa の Team 名||

## 起動方法(初回のみ)

```
git clone https://github.com/ryu-sato/growi-importer-esa.git
cd growi-importer-esa
bundle install
./bin/rails db:migrate
```

## 簡易UI起動方法

※ 初回起動時は「起動方法(初回のみ)」の実施が必要

```
cd ${cloneしたgrowi-importer-esaのディレクトリ}
./bin/rails s
```

rails s を実行した後、`http://localhost:3000/` へアクセスすると簡易 UI が使えます。

## Rake タスク実行方法

※ 初回起動時は「起動方法(初回のみ)」の実施が必要

### esa から DB へデータをインポート

```
./bin/rake esa:import_to_db
```

### DB から GROWI へデータをエクスポート

```
./bin/rake esa:export_to_growi
```

# Ruby and Ruby on Rails versions

- Ruby: 2.5.x
- Ruby On Rails: 5.1.x

## System dependencies

- crowi-client
- esa

# TODO

- [x] `esa:export_to_growi` タスクにて添付ファイルもアップロードできるようにする
- [x] メニューバーから Rake Task を実行できるようにする
- [ ] Attachments の詳細ページや編集ページを開いた時にエラーが出ないようにする
- [ ] Post / User の編集・削除操作をリンクから辿れるようにする
- [x] Token や URL の設定をアプリケーションで操作できるようにする
