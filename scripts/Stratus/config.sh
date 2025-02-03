#!/bin/bash
#VM instance configuration
#Author: Diogo Gouveia (ehxa)
#Version: 20250103 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

sudo mkdir -p $HOME/wrf && \
sudo mkdir -p /WRF && \
sudo mount /dev/sdb1 /WRF || true && \
sudo mkdir -p /GEOG && \
sudo mount /dev/sdc1 /GEOG || true && \
sudo mkdir -p /LOGS && \
sudo mount /dev/sdd1 /LOGS || true && \
sudo tar -xvf /WRF/wrfcompiled.tar -C /home/ubuntu/ && \
sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/ubuntu/wrf/ARM/ && \
sudo apt update && \
sudo apt install -y make libxml2-dev m4 libcurl4-openssl-dev libtool csh && \
sudo apt-get -y install gcc-9 g++-9 gfortran-9 && \
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9 && \
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9 && \
sudo update-alternatives --set gcc /usr/bin/gcc-9 && \
sudo update-alternatives --set g++ /usr/bin/g++-9 && \
sudo ln -s /usr/bin/gfortran-9 /usr/bin/gfortran && \
gcc --version && \
g++ --version && \
gfortran --version && \
cd $HOME && wget https://raw.githubusercontent.com/ehxa/OOM-Internship/refs/heads/main/scripts/Stratus/wrf_run.sh && chmod u+x wrf_run.sh && \
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done && sudo apt-get update -y && sudo apt-get install -y ca-certificates curl && sudo install -m 0755 -d /etc/apt/keyrings && sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && sudo chmod a+r /etc/apt/keyrings/docker.asc && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && sudo apt-get update -y && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && sudo groupadd docker && sudo usermod -aG docker ubuntu && newgrp docker && \
sudo docker pull ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured && \
sudo docker run -d --name ubuntu24.04-wrf-gcc ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured tail -f /dev/null && \
sudo docker cp /WRF/wrf_input.tar.gz ubuntu24.04-wrf-gcc:/WRF/ && \
sudo docker exec ubuntu24.04-wrf-gcc bash -c "sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/swe/wrf/ARM/ && ln -s /home/swe/wrf/ARM/wrf_tmp/* /home/swe/wrf/WRF/WRF/run/" && \
sudo docker stop ubuntu24.04-wrf-gcc && \
sudo systemctl stop docker && \
sudo systemctl stop docker.socket && \
cd $HOME/wrf/WRF/WRF/run && \
mv namelist.input namelist.input.backup && \
sudo ln -s /home/ubuntu/wrf/ARM/wrf_tmp/* /home/ubuntu/wrf/WRF/WRF/run
cd $HOME