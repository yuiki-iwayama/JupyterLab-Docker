# JupyterLab-Docker

## Overview
- データサイエンスに最低限必要なJupyterLab（Python3.9）の環境
- encodingはja_JP.UTF-8に設定，timizoneはAsia/Tokyoに設定
- Julia1.7.1に対応

## 動作環境（確認済）
- macOS Monterey 12.0.1
- Docker Desktop 4.3.2 (for Mac)
※intel Macの方はDockerfileのコメントアウトを書き換えてください

## Install
- buildする前にrequirements.txtを見て必要なPythonライブラリを適宜追加・変更してください
- buildする前にpackages.jlを見て必要なJuliaライブラリを適宜・追加変更してください
```
$ git clone git@github.com:yuiki-iwayama/JupyterLab-Docker.git
$ cd JupyterLab-Docker
$ docker-compose up -d --build
```

## Usage
- JupyterLab\
http://localhost:8888

## Document
- workバインドマウントを./に配置