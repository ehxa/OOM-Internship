FROM intel/hpckit:latest
LABEL version="0.3"

#
# Set up base OS environment
#
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sudo python3 perl tar wget git m4 csh cmake build-essential vim libxml2-dev libcurl4-openssl-dev curl libtool locate locales
RUN locale-gen en_US.UTF-8

#
# Create user
#
RUN useradd -m swe
RUN echo "swe ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/swe
USER swe
WORKDIR /home/swe

#
# setup environment
#
ENV HOME="/home/swe"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"
RUN echo "alias cp='cp -iv'" >> ~/.bashrc && \
    echo "alias mv='mv -iv'" >> ~/.bashrc && \
    echo "alias mkdir='mkdir -pv'" >> ~/.bashrc && \
    echo "alias ll='ls -FGlAhp'" >> ~/.bashrc