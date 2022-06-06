FROM jupyter/scipy-notebook:latest
USER root

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
    ca-certificates \
    xclip

#タイムゾーンの設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# condaでインストール
COPY ./docker/base.txt /tmp/base.txt
RUN conda update -n base -c defaults conda -y \
  && conda install -n base -c conda-forge --file /tmp/base.txt -y \
  && conda clean -a -y \
  && rm /tmp/base.txt

# pipでインストール
COPY ./docker/requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip \
  && pip install --no-cache-dir -r /tmp/requirements.txt \
  && rm /tmp/requirements.txt

# JuliaとJuliaのパッケージをインストール
WORKDIR /opt
ENV JULIA_VERSION julia-1.7.2
COPY ./docker/packages.jl /tmp/packages.jl
RUN wget https://julialang-s3.julialang.org/bin/linux/aarch64/1.7/${JULIA_VERSION}-linux-aarch64.tar.gz \
  && tar zxvf ${JULIA_VERSION}-linux-aarch64.tar.gz \
  && ln -s /opt/${JULIA_VERSION}/bin/julia /usr/local/bin/julia \
  && julia /tmp/packages.jl \
  && rm ${JULIA_VERSION}-linux-aarch64.tar.gz /tmp/packages.jl

# GitHubからsshでcloneするための設定
ARG GITHUB_USER
ARG GITHUB_EMAIL
RUN mkdir -p ~/.ssh \
  && git config --global user.name "${GITHUB_USER}" \
  && git config --global user.email ${GITHUB_EMAIL}
COPY ./docker/config /root/.ssh
COPY ./docker/init.sh /usr/bin

COPY ./docker/import_path.pth /opt/conda/lib/python3.10/site-packages/import_path.pth
RUN apt-get autoremove -y \
  && apt-get clean
WORKDIR /work

CMD ["/bin/bash", "/usr/bin/init.sh"]