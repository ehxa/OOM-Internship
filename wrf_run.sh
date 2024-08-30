#!/bin/bash
# Script for showing WRF start and end (date and time)
echo "Welcome to WRF!"
re='^[0-9]+$'
cpu=""

read -p "How many CPUs?" cpu

while ! [[ $cpu =~ $re ]]; do
    echo "Invalid option, try again."
    read -p "How many CPUs?" cpu
done

echo "How do you want to run it? Single-run (s) or Incrementally (i)"
read choice

while [[ $choice != "i" && $choice != "s" ]]; do
    echo "Invalid option, try again."
    read -p "How do you want to run it? Single-run (s) or Incrementally (i)" choice
done

[[ $choice == "i" ]] && j=1 || j=$cpu

while [[ $j -le $cpu ]]; do
    echo "WRF with $j CPU(s) started"
    date
    #mpirun -np $j ./wrf.exe
    date
    echo "WRF with $j CPU(s) finished"
    ((j++))
done
