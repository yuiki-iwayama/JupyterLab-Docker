# PostgreSQL-JupyterLab-Docker

## Overview
- JupyterLab-PostgreSQLの相互環境(接続できるかの最低限の設定)
- encodingはja_JP.UTF-8に設定，timizoneはAsia/Tokyoに設定
- pystan 2.19.1.1も動かせる

## 動作環境（確認済）
- macOS BigSur 11.5.1
- Docker Desktop(macOS) 20.10.7

## Install
```
$ git clone git@github.com:yuiki-iwayama/JupyterLab-Postgres-Docker.git
$ cd JupyterLab-Postgres-Docker
$ docker-compose up -d --build
```

## Usage
- JupyterLab\
http://localhost:8888

- JupyterLabからSQLを動かす
```
# SQL の拡張機能を呼び出す
%load_ext sql

# DB 接続に必要な engine を取得（portはコンテナ側を指定する）
dsl = 'postgres://{user}:{password}@{container_name:port}/{database}'

# sql に接続
%sql $dsl
```
- localからSQLを動かす
```
$ docker-compose exec db bash
# psql -U admin -h localhost -d analysis
```
## Document
- workディレクトリをローカルに配置
- db-dataディレクトリをローカルに配置
