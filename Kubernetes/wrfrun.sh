#!/bin/bash
kubectl exec wrf-arm5-master -- bash -c "
. /home/swe/wrf/gccvars.sh &&
cd /home/swe/wrf/WRF/WRF/run/ &&
cp /mnt/data/* . &&
timeout 60s mpirun -np 4 --hostfile hosts.txt ./wrf.exe || true &&
echo 'WRF job completed' &&
echo '' &&
echo 'rsl.error.0000:' &&
tail -n 15 rsl.error.0000 &&
echo 'rsl.out.0000:' &&
tail -n 15 rsl.out.0000 &&
cp rsl.error.0000 /mnt/data/rsl.error.0000 &&
cp rsl.out.0000 /mnt/data/rsl.out.0000
"
