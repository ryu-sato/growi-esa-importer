# What is growi-importer-esa

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

- crowi-client
    - `config/settings` に Crowi(GROWI) の URL と API token を設定します
```yml
development:
  url:   http://192.168.2.104:3001/
  token: 123456789abcdef123456789abcdef123456789abcde
```
- 
    - `env` を作成して esa の Access Token とインポート対象とする Team 名を設定します
```
ESA_ACCESS_TOKEN=123456789abcdef123456789abcdef123456789abcdef123456789abcdef1234
ESA_CURRENT_TEAM=foo-bar-team
```

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

- [ ] `esa:export_to_growi` タスクにて添付ファイルもアップロードできるようにする
- [ ] メニューバーから Rake Task を実行できるようにする
- [ ] Attachments の詳細ページや編集ページを開いた時にエラーが出ないようにする
- [ ] Post / User の編集・削除操作をリンクから辿れるようにする
- [ ] Token や URL の設定をアプリケーションで操作できるようにする
