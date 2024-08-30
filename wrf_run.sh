#!/bin/bash
# Script for showing WRF start and end (date and time)
echo "Welcome to WRF!"
re='^[0-9]+$'
cpu=""

echo "How many CPUs?"
read cpu

while ! [[ $cpu =~ $re ]]; do
    echo "Invalid option, try again."
    echo "How many CPUs?"
    read cpu
done

echo "How do you want to run it? Single-run (s) or Incrementally (i)"
read choice

while [[ $choice != "i" && $choice != "s" ]]; do
    echo "Invalid option, try again."
    echo "How do you want to run it? Single-run (s) or Incrementally (i)"
    read choice
done

[[ $choice == "i" ]] && j=0 || j=$cpu

while [[ $j -le $cpu ]]; do
    echo "WRF with $j CPU(s) started"
    date
    #mpirun -np $j ./wrf.exe
    date
    echo "WRF with $j CPU(s) finished"
    ((j++))
done
