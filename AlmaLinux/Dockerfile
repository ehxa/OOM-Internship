FROM almalinux:8.10-minimal
LABEL version="0.1"

RUN microdnf -y update && \
    microdnf install -y epel-release && \
    microdnf install -y \
    glibc-langpack-en sudo file libpng-devel vim python3 hostname m4 make perl tar bash tcsh time wget which git cmake pkgconfig libxml2-devel libcurl-devel openssh-clients openssh-server net-tools fontconfig libXext libXrender ImageMagick gmp-devel mpfr-devel libmpc-devel gcc-toolset-9 && \
    microdnf clean all && \
    useradd -m swe && \
    echo "swe ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/swe && \
    echo "alias cp='cp -iv'" >> /home/swe/.bashrc && \
    echo "alias mv='mv -iv'" >> /home/swe/.bashrc && \
    echo "alias mkdir='mkdir -pv'" >> /home/swe/.bashrc && \
    echo "alias ll='ls -FGlAhp'" >> /home/swe/.bashrc && \
    echo "source scl_source enable gcc-toolset-9" >> /etc/profile.d/gcc9.sh

USER swe
WORKDIR /home/swe

ENV HOME="/home/swe" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"