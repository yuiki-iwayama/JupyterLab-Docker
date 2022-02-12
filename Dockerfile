FROM continuumio/anaconda3:latest

# 必要なパッケージを入れる.
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-ipaexfont \
    libgl1-mesa-dev \
    build-essential \
    ca-certificates \
    cmake \
    gcc \
    g++ \
    openssh-client \
    bash-completion \
    vim \
    software-properties-common \
    dirmngr \
    gnupg \
    apt-transport-https \
    ca-certificates

# Debianの設定
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

# condaでインストール
COPY base.txt /tmp/base.txt
RUN conda update -n base -c defaults conda -y \
  && conda install -n base -c conda-forge --file /tmp/base.txt -y \
  && conda clean -a -y \
  && rm /tmp/base.txt

# pipでインストール
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip \
  && pip install --no-cache-dir -r /tmp/requirements.txt \
  && rm /tmp/requirements.txt

# RとRライブラリのインストール
RUN apt-get update && apt-get install -y r-base \
  && Rscript -e "install.packages(c('tidyverse', 'dplyr'), dependencies = TRUE, error = TRUE)"

# JuliaとJuliaのパッケージをインストール
WORKDIR /opt
ENV JULIA_VERSION julia-1.7.2
COPY packages.jl /tmp/packages.jl
RUN wget https://julialang-s3.julialang.org/bin/linux/aarch64/1.7/${JULIA_VERSION}-linux-aarch64.tar.gz \
  && tar zxvf ${JULIA_VERSION}-linux-aarch64.tar.gz \
  && ln -s /opt/${JULIA_VERSION}/bin/julia /usr/local/bin/julia \
  && julia /tmp/packages.jl \
  && rm ${JULIA_VERSION}-linux-aarch64.tar.gz /tmp/packages.jl

# GitHubからsshでcloneするための設定
ARG GITHUB_USER
ARG GITHUB_EMAIL
RUN mkdir -p ~/.ssh \
  && git config --global user.name "${GITHUB_USER}"  \
  && git config --global user.email ${GITHUB_EMAIL}
COPY config /root/.ssh
COPY init.sh /usr/bin

RUN apt-get autoremove -y \
  && apt-get clean
WORKDIR /work

CMD ["/bin/bash", "/usr/bin/init.sh"]