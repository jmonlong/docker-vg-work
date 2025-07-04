FROM ubuntu:20.04

MAINTAINER jmonlong@ucsc.edu

# Prevent dpkg from trying to ask any questions, ever
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3 \
    python3-dev \
    build-essential \
    cmake \
    wget \
    git \
    ca-certificates \
    g++ \
    gcc \
    make \
    doxygen \
    pkg-config \
    libjansson-dev \
    graphviz \
    zlib1g-dev \
    libbz2-dev \
    libncurses5-dev \
    liblzma-dev \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /bin

## vg
RUN wget --quiet --no-check-certificate https://github.com/vgteam/vg/releases/download/v1.66.0/vg && \
    chmod +x vg

ENV PATH=$PATH:/bin

WORKDIR /opt

## samtools
RUN wget --quiet --no-check-certificate https://github.com/samtools/samtools/releases/download/1.20/samtools-1.20.tar.bz2 && \
        tar -xjf samtools-1.20.tar.bz2 && \
        cd samtools-1.20 && \
        ./configure && make && make install && \
        cd .. && rm -rf samtools-1.20.tar.bz2 samtools-1.20

## freebayes
RUN git clone -b v1.2.0 https://github.com/freebayes/freebayes/ && \
    cd freebayes && \
    git submodule update --init --recursive && \
    make && make install && \
    cd .. && rm -rf freebayes

## seqtk
RUN wget --quiet --no-check-certificate https://github.com/lh3/seqtk/archive/refs/tags/v1.4.tar.gz && \
        tar -xzf v1.4.tar.gz && \
        cd seqtk-1.4 && \
        make && make install && \
        cd .. && rm -rf v1.4.tar.gz seqtk-1.4

## picard
RUN wget --quiet --no-check-certificate https://github.com/broadinstitute/picard/releases/download/3.2.0/picard.jar

RUN echo '#!/bin/bash\njava -jar /opt/picard.jar "$@"' > /bin/picard && \
    chmod +x /bin/picard

## python and libbdsg
WORKDIR /opt

RUN git clone --recursive https://github.com/vgteam/libbdsg.git && \
    mkdir libbdsg/build && \
    cd libbdsg/build && \
    cmake .. && \
    make -j 4

ENV PYTHONPATH $PYTHONPATH:/opt/libbdsg/lib

## htslib 1.20 for bgzip and tabix
RUN wget --quiet  --no-check-certificate https://github.com/samtools/htslib/releases/download/1.20/htslib-1.20.tar.bz2 && \
    tar -xjvf htslib-1.20.tar.bz2 && \
    cd htslib-1.20 && \
    ./configure  && \
    make  && \
    make install && \
    cd .. && \
    rm -rf htslib-1.20 htslib-1.20.tar.bz2

## helper scripts
COPY rename_bam_stream.py /opt/scripts/

COPY subset_fastq_seqtk.py /opt/scripts/

WORKDIR /app
