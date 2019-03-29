# If you change this dockerfile, run `make publish-ci-docker-images`.

FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        curl \
        expect \
        expect-dev \
        gdb \
        gir1.2-gstreamer-1.0 \
        git \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-tools \
        gzip \
        language-pack-en \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libopencv-dev \
        liborc-0.4-dev \
        librsvg2-bin \
        moreutils \
        pep8 \
        pylint \
        python-docutils \
        python-flask \
        python-gi \
        python-jinja2 \
        python-kitchen \
        python-libcec \
        python-lmdb \
        python-lxml \
        python-mock \
        python-nose \
        python-numpy \
        python-opencv \
        python-pip \
        python-pysnmp4 \
        python-requests \
        python-scipy \
        python-serial \
        python-yaml \
        socat \
        ssh \
        sudo \
        tar \
        tesseract-ocr \
        tesseract-ocr-deu \
        tesseract-ocr-eng \
        time \
        wget \
        xterm && \
    apt-get clean

RUN pip install \
        astroid==1.6.0 \
        isort==4.3.4 \
        pylint==1.8.3 \
        pytest==3.3.1 \
        responses==0.5.1

# Ubuntu parallel package conflicts with moreutils, so we have to build it
# ourselves.
RUN mkdir -p /src && \
    cd /src && \
    { wget http://ftpmirror.gnu.org/parallel/parallel-20140522.tar.bz2 || \
      wget http://ftp.gnu.org/gnu/parallel/parallel-20140522.tar.bz2 || \
      exit 0; } && \
    tar -xvf parallel-20140522.tar.bz2 && \
    cd parallel-20140522/ && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd && \
    rm -rf /src && \
    mkdir -p $HOME/.parallel && \
    touch $HOME/.parallel/will-cite  # Silence citation warning
