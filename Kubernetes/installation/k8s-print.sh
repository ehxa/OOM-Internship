#!/bin/bash
nproc=$(nproc)
n=0
while [[ $n -lt $nproc ]]; do
    file=$(printf "%04d" $n)
    echo ""
    echo "rsl.error.$file result (Kubernetes):"
    tail rsl.error.$file
    echo ""
    echo "rsl.out.$file result (Kubernetes):"
    tail rsl.out.$file
    ((n++))
done
echo ""
echo "Present wrfout files (Kubernetes):"
ls -ls wrfout*
echo ""