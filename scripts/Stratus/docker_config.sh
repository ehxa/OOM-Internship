#!/bin/bash
#Docker in instance configuration
#Author: Diogo Gouveia (ehxa)
#Version: 20250130 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

docker pull ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured
docker run -d --name ubuntu24.04-wrf-gcc ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured
docker cp /WRF/wrf_input.tar.gz ubuntu24.04-wrf-gcc:/WRF/
docker start ubuntu24.04-wrf-gcc
docker exec ubuntu24.04-wrf-gcc bash -c "sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/swe/wrf/ARM/ && sudo ln -s /home/swe/wrf/ARM/wrf_tmp/* ."
docker stop ubuntu24.04-wrf-gcc