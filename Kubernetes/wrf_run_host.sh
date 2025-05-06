#!/bin/bash
kubectl exec wrf-arm-master -- bash -c "
. /home/swe/wrf/gccvars.sh &&
ln -s /home/swe/wrf/WRF/WRF/run/* /mnt/data || true &&
cd /mnt/data &&
timeout 60s mpirun -np 2 --hostfile hosts.txt ./wrf.exe || true &&
echo 'WRF job completed' &&
echo '' &&
echo 'rsl.error.0000:' &&
tail -n 15 rsl.error.0000 &&
echo 'rsl.out.0000:' &&
tail -n 15 rsl.out.0000"