#!/bin/bash
#Docker in instance configuration
#Author: Diogo Gouveia (ehxa)
#Version: 20250203 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

docker pull ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured
docker run -d --name ubuntu24.04-wrf-gcc ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured tail -f /dev/null
docker cp /WRF/wrf_input.tar.gz ubuntu24.04-wrf-gcc:/WRF/
docker exec ubuntu24.04-wrf-gcc bash -c "sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/swe/wrf/ARM/ && ln -s /home/swe/wrf/ARM/wrf_tmp/* /home/swe/wrf/WRF/WRF/run/"
docker stop ubuntu24.04-wrf-gcc