#!/bin/bash
# Script for showing WRF start and end (date and time)
echo "Welcome to WRF!"
echo ""
re='^[0-9]+$'
host_cpu=$(nproc)
date=$(date)
{
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
    echo ""
    echo "WRF with $j CPU(s) started"
    date
    #mpirun -np $j ./wrf.exe
    date 
    n=0 #count variable to print all rsl.out files
    while [[ $n -lt $j ]]; do
        echo ""
        echo "rsl.error.000$n result:"
        tail rsl.error.000$n
        echo ""
        echo "rsl.out.000$n result:"
        tail rsl.out.000$n
        ((n++))
    done
    echo ""
    echo "WRF with $j CPU(s) finished"
    ((j++))
done
} 2>&1 | tee -a $HOME/wrf/OOM-Internship/logs/wrf_$date.log