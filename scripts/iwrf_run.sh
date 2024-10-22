#!/bin/bash
# Script for showing WRF start and end (date and time)
echo "Welcome to WRF!"
echo ""
re='^[0-9]+$'
host_cpu=$(nproc)
date=$(date +"%Y%m%d-%H%M%S")
j=1

read -p "Which location do you want to run it? em_real (e) or run (r): " which

while [[ $which != "e" && $which != "r" ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "Which location do you want to run it? em_real (e) or run (r): " which
done

if [[ $which == "e" ]]; then
    location="test/em_real"
else
    location="run"
fi

read -p "How do you want to run it? Single-run (s) or Incrementally (i): " how

while [[ $how != "i" && $how != "s" ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "How do you want to run it? Single-run (s) or Incrementally (i): " how
done

read -p "Where do you want to run it? Native (n), Docker (d) or Mixed (m): " where

echo ""

printNative () {
    n=0 #count variable to print all rsl.out files
    while [[ $n -lt $native_cpu ]]; do
        echo ""
        echo "rsl.error.000$n result (Native):"
        tail rsl.error.000$n
        echo ""
        echo "rsl.out.000$n result (Native):"
        tail rsl.out.000$n
        ((n++))
    done
    echo ""
    echo "Present wrfout files (Native):"
    ls -ls wrfout*
    echo ""
    rm -rf rsl* && rm -rf wrfout*
}

runNative () {
    echo "WRF with $native_cpu CPU(s) started natively"
    echo "Start (Native): $(date)"
    if [[ $which == "r" ]]; then
        . /home/wrfuser/iwrfvars.sh && cd /home/wrfuser/WRF/$location &&  timeout 3600s mpirun -np $native_cpu ./wrf.exe;
    else
        . /home/wrfuser/iwrfvars.sh && cd /home/wrfuser/WRF/$location && mpirun -np $native_cpu ./wrf.exe;
    fi
    echo "Finish (Native): $(date)"
    printNative
}

{
if [[ $where == "n" ]]; then 
    read -p "How many CPUs? (Max: $host_cpu): " cpu
    while ! [[ $cpu =~ $re ]] || [[ $cpu -gt $host_cpu ]]; do
        echo "Invalid option, try again."
        echo ""
        read -p "How many CPUs? (Max: $host_cpu): " cpu
    done
    [[ $how == "i" ]] && {
        native_cpu=1; 
        echo "Beginning WRF with $cpu cycles in Incremental and Native modes";
        while [[ $native_cpu -le $cpu ]]; do
            runNative;
            echo "WRF with $native_cpu CPU(s) finished"
            ((native_cpu++))
        done
    } || {
        native_cpu=$cpu; 
        echo "Beginning WRF with $cpu CPU(s) in Single-run and Native modes"; 
        runNative;
        echo "WRF with $cpu CPU(s) finished"
    }
fi
} 2>&1 | tee -a /home/wrfuser/logs/wrf_$date.log