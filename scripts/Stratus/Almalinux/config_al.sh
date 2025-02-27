#!/bin/bash
#VM instance configuration (Almalinux)
#Author: Diogo Gouveia (ehxa)
#Version: 20250207 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

sudo mkdir -p $HOME/wrf
sudo mkdir -p /WRF
sudo mount /dev/sdb1 /WRF || true
sudo mkdir -p /GEOG
sudo mount /dev/sdc1 /GEOG || true
sudo mkdir -p /LOGS
sudo mount /dev/sdd1 /LOGS || true
sudo tar -xvf /WRF/wrfcompiled.tar -C /home/almalinux/
sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/almalinux/wrf/ARM/
sudo dnf -y update
sudo dnf install -y epel-release
sudo dnf install -y glibc-langpack-en file libpng-devel vim python3 hostname m4 make perl tar bash tcsh time wget which git cmake pkgconfig libxml2-devel libcurl-devel openssh-clients openssh-server net-tools fontconfig libXext libXrender ImageMagick gmp-devel mpfr-devel libmpc-devel gcc-toolset-9
sudo dnf clean all
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9
sudo update-alternatives --set gcc /usr/bin/gcc-9
sudo update-alternatives --set g++ /usr/bin/g++-9
sudo ln -s /usr/bin/gfortran-9 /usr/bin/gfortran
gcc --version
g++ --version
gfortran --version
cd $HOME && wget https://raw.githubusercontent.com/ehxa/OOM-Internship/refs/heads/main/scripts/Stratus/wrf_run.sh && chmod u+x wrf_run.sh
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo docker pull ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured
sudo docker run -d --name ubuntu24.04-wrf-gcc ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured tail -f /dev/null
sudo docker cp /WRF/wrf_input.tar.gz ubuntu24.04-wrf-gcc:/WRF/
sudo docker exec ubuntu24.04-wrf-gcc bash -c "mkdir -p /home/swe/wrf/ARM && sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/swe/wrf/ARM/ && ln -s /home/swe/wrf/ARM/wrf_tmp/* /home/swe/wrf/WRF/WRF/run/"
sudo docker stop ubuntu24.04-wrf-gcc
sudo systemctl stop docker
sudo systemctl stop docker.socket
cd $HOME/wrf/WRF/WRF/run
mv namelist.input namelist.input.backup
ln -s /home/almalinux/wrf/ARM/wrf_tmp/* /home/almalinux/wrf/WRF/WRF/run
cd $HOME