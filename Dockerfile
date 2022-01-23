FROM python:slim-buster
USER root

# Debianにツールをインストール
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    fonts-ipaexfont \
    build-essential \
    libgl1-mesa-dev \
    xsel \
    xclip \
    software-properties-common \
    ca-certificates \
    cmake \
    gcc \
    g++ \
    curl \
    git

# Debianの設定
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

# Pythonのライブラリーインストール
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip \
  && pip install --upgrade setuptools wheel\
  && pip install --no-cache-dir -r /tmp/requirements.txt \
  && rm /tmp/requirements.txt
  
# lightgbmのインストール
RUN git clone --recursive --branch stable --depth 1 https://github.com/Microsoft/LightGBM \
  && cd LightGBM/python-package \
  && python setup.py install \
  && sed -i '/language/a\ "env": {"LD_PRELOAD":"/usr/lib/aarch64-linux-gnu/libgomp.so.1"},' /usr/local/share/jupyter/kernels/python3/kernel.json \
  && rm -rf /usr/local/src/*

# Juliaのインストール(intelのときはjulia-1.7.1-linux-x86_64.tar.gzに変更する)
COPY packages.jl /tmp/packages.jl
WORKDIR /opt
RUN wget https://julialang-s3.julialang.org/bin/linux/aarch64/1.7/julia-1.7.1-linux-aarch64.tar.gz \
  && tar zxvf julia-1.7.1-linux-aarch64.tar.gz \
  && ln -s /opt/julia-1.7.1/bin/julia /usr/local/bin/julia
# Juliaのライブラリーインストール
RUN julia /tmp/packages.jl \
  && rm julia-1.7.1-linux-aarch64.tar.gz /tmp/packages.jl

RUN apt-get autoremove -y && apt-get clean
WORKDIR /
