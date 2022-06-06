# JupyterLab-Docker

## Overview
- データサイエンスに最低限必要なJupyterLab（Python3.10）の環境
- 日本語対応，timizoneはJST-9に設定
- Julia1.7.3に対応
- GitHub環境をすぐ作れるように対応

## 動作環境（確認済）
- macOS Monterey 12.3.1
- Docker Desktop 4.7.1 (for Mac)\
※intel Macの方はJuliaのインストールをx86_64のファイル名に書き換えてください\
https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.3-linux-x86_64.tar.gz


## Install
- buildする前にbase.txtとrequirements.txtを見て必要なPythonライブラリを適宜追加・変更してください
- buildする前にpackages.jlを見て必要なJuliaライブラリを適宜・追加変更してください
- buildする前に~/.sshにsshキーを作成し，公開鍵をGitHubに登録してください
- buildする前に.envに必要事項を記載してください
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
