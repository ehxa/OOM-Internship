#!/bin/bash
#Docker in instance configuration
#Author: Diogo Gouveia (ehxa)
#Version: 20250130 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

docker pull ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured
docker run -it -d --name pull ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured
docker cp /WRF/wrf_input.tar.gz ubuntu24.04-wrf-gcc:/WRF/
docker exec container bash -c "sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/ubuntu/wrf/ARM/ && sudo ln -s /home/ubuntu/wrf/ARM/wrf_tmp/* ."
docker stop ubuntu24.04-wrf-gcc