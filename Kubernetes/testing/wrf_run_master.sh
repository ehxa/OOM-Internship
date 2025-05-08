#!/bin/bash
ln -s /home/swe/wrf/WRF/WRF/run/* /mnt/data &&
cd /mnt/data &&
timeout 60s mpirun -np 2 --hostfile hosts.txt ./wrf.exe &&
echo 'WRF job completed' &&
echo '' &&
echo 'rsl.error.0000:' &&
tail -n 15 rsl.error.0000 &&
echo 'rsl.out.0000:' &&
tail -n 15 rsl.out.0000