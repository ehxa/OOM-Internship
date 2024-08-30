#!/bin/bash
# Script for showing WRF start and end (date and time)
echo "Welcome to WRF!"
echo ""
re='^[0-9]+$'
host_cpu=$(nproc)

read -p "How many CPUs? (Max: $host_cpu): " cpu

while ! [[ $cpu =~ $re ]] || [[ $cpu -gt $host_cpu ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "How many CPUs? (Max: $host_cpu): " cpu
done

read -p "How do you want to run it? Single-run (s) or Incrementally (i): " choice

while [[ $choice != "i" && $choice != "s" ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "How do you want to run it? Single-run (s) or Incrementally (i): " choice
done

[[ $choice == "i" ]] && j=1 || j=$cpu

while [[ $j -le $cpu ]]; do
    echo "WRF with $j CPU(s) started"
    date
    mpirun -np $j ./wrf.exe
    date
    echo "WRF with $j CPU(s) finished"
    echo ""
    ((j++))
done