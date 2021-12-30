FROM python:latest
USER root

# Debianの設定
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    fonts-ipaexfont \
    build-essential
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

# PythonとPythonのライブラリーインストール
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip \
  && pip install --upgrade setuptools \
  && pip install --no-cache-dir -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt

# JuliaとJuliaのライブラリーインストール
COPY packages.jl /tmp/packages.jl
WORKDIR /opt
RUN wget https://julialang-s3.julialang.org/bin/linux/aarch64/1.7/julia-1.7.1-linux-aarch64.tar.gz
# intelのときはwget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.1-linux-x86_64.tar.gz
RUN tar zxvf julia-1.7.1-linux-aarch64.tar.gz
# intelのときはtar zxvf julia-1.7.1-linux-x86_64.tar.gz
RUN ln -s /opt/julia-1.7.1/bin/julia /usr/local/bin/julia
RUN julia /tmp/packages.jl
RUN rm julia-1.7.1-linux-aarch64.tar.gz /tmp/packages.jl
# intelのときはrm julia-1.7.1-linux-x86_64.tar.gz/tmp/packages.jl

WORKDIR /