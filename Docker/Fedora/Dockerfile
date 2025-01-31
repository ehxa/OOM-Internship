FROM fedora:40
LABEL version="0.1"

#
# Set up base OS environment
#
RUN dnf -y update && \
    dnf -y install glibc-langpack-en sudo file libpng-devel vim python3 hostname m4 make perl tar bash tcsh time wget which git cmake pkgconfig libxml2-devel libcurl-devel openssh-clients openssh-server net-tools fontconfig libXext libXrender ImageMagick gmp-devel mpfr-devel libmpc-devel
#
# Create user
#
RUN useradd -m swe && \
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