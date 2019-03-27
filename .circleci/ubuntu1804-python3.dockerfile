# If you change this dockerfile, run `make publish-ci-docker-images`.

FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        curl \
        expect \
        expect-dev \
        gdb \
        gir1.2-gstreamer-1.0 \
        gir1.2-gudev-1.0 \
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
        lighttpd \
        moreutils \
        parallel \
        pep8 \
        pylint3 \
        python3-dev \
        python3-docutils \
        python3-flask \
        python3-gi \
        python3-jinja2 \
        python3-kitchen \
        python3-libcec \
        python3-lxml \
        python3-matplotlib \
        python3-mock \
        python3-nose \
        python3-numpy \
        python3-opencv \
        python3-pip \
        python3-pysnmp4 \
        python3-pytest \
        python3-qrcode \
        python3-requests \
        python3-responses \
        python3-scipy \
        python3-serial \
        python3-yaml \
        python3-zbar \
        socat \
        ssh \
        sudo \
        tar \
        tesseract-ocr \
        time \
        v4l-utils \
        wget \
        xterm && \
    apt-get clean

RUN mkdir -p $HOME/.parallel && \
    touch $HOME/.parallel/will-cite  # Silence citation warning

# Tesseract data files for Legacy *and* LSTM engines.
ADD https://github.com/tesseract-ocr/tessdata/raw/590567f/deu.traineddata \
    https://github.com/tesseract-ocr/tessdata/raw/590567f/eng.traineddata \
    https://github.com/tesseract-ocr/tessdata/raw/590567f/osd.traineddata \
    /usr/share/tesseract-ocr/4.00/tessdata/

# Work around python-libcec packaging bug
# https://bugs.launchpad.net/ubuntu/+source/libcec/+bug/1822066
RUN mv /usr/lib/python2.7.15rc1/dist-packages/cec /usr/lib/python2.7/dist-packages/
