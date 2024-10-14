FROM ehxa/oom:opensuse-tumbleweed-20241007-base
LABEL version="0.8"

#
# Set up base OS environment
#

RUN zypper -n --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/devel:gcc/openSUSE_Factory/devel:gcc.repo && \
    zypper -n --gpg-auto-import-keys refresh && \
    zypper -n update && \
    zypper -n install glibc-locale sudo file libpng16-devel vim python313 gawk autoconf automake libtool tcsh\
    hostname m4 make perl time wget which git cmake pkgconf libxml2-devel libcurl-devel \
    openssh net-tools fontconfig libXext6 libXrender1 ImageMagick gcc9 gcc9-c++ gcc9-fortran && \
    zypper clean --all && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100 && \
    update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-9 100

#
# Create user
#g
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