FROM ubuntu:24.04
LABEL version="0.4"

#
# Set up base OS environment
#
RUN apt-get update -y && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo python3 perl tar wget git m4 csh cmake build-essential vim \
    libxml2-dev libcurl4-openssl-dev curl libtool locate locales && \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

#
# Create user
#
RUN useradd -m -s /bin/bash -G sudo swe && \
    echo "swe ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/swe

USER swe
WORKDIR /home/swe

#
# Setup environment
#
ENV HOME="/home/swe"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

RUN echo "alias cp='cp -iv'" >> ~/.bashrc && \
    echo "alias mv='mv -iv'" >> ~/.bashrc && \
    echo "alias mkdir='mkdir -pv'" >> ~/.bashrc && \
    echo "alias ll='ls -FGlAhp'" >> ~/.bashrc