#!/bin/bash
# Script for showing WRF start and end (date and time)
echo "Welcome to WRF!"
echo ""
re='^[0-9]+$'
host_cpu=$(nproc)
date=$(date +"%Y%m%d-%H%M%S")
j=1

read -p "How do you want to run it? Single-run (s) or Incrementally (i): " how

while [[ $how != "i" && $how != "s" ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "How do you want to run it? Single-run (s) or Incrementally (i): " how
done

read -p "Where do you want to run it? Native (n), Docker (d) or Mixed (m): " where

while [[ $where != "n" && $where != "d" && $where != "m"  ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "Where do you want to run it? Native (n), Docker (d) or Mixed (m): " where
done

echo ""

printOutput () {
    n=0 #count variable to print all rsl.out files
    while [[ $n -lt $native_cpu || $n -lt $docker_cpu ]]; do
        echo ""
        echo "rsl.error.000$n result:"
        tail rsl.error.000$n
        echo ""
        echo "rsl.out.000$n result:"
        tail rsl.out.000$n
        ((n++))
    done
    echo ""
    echo "Present wrfout files:"
    ls -ls wrfout*
    echo ""
    rm -rf rsl* && rm -rf wrfout*
}

runDocker () {
    docker start ubuntu24.04-wrf-gcc;
    echo "WRF with $docker_cpu CPU(s) started in Docker"
    echo "Start (Docker): $(date)"
    docker exec -i ubuntu24.04-wrf-gcc bash -c ". /home/swe/wrf/gccvars.sh && cd /home/swe/wrf/WRF/WRF/test/em_real && mpirun -np $docker_cpu ./wrf.exe;"
    echo "Finish (Docker): $(date)"
    printOutput
    docker stop ubuntu24.04-wrf-gcc;
}

startDocker () {
    if [[ $j -eq 1 ]]; then
        systemctl --user start docker-desktop; 
        sleep 20;
    fi
}

stopDocker () {
    systemctl --user stop docker-desktop; 
}

runNative () {
    echo "WRF with $native_cpu CPU(s) started natively"
    echo "Start (Native): $(date)"
    . $HOME/wrf/gccvars.sh && cd $HOME/wrf/WRF/WRF/test/em_real && mpirun -np $native_cpu ./wrf.exe;
    echo "Finish (Native): $(date)"
    printOutput
}

{
if [[ $where == "m" ]]; then
    [[ $how == "i" ]] && {
        native_cpu=1; 
        docker_cpu=$((host_cpu - 1))
        echo "Beginning WRF with $docker_cpu cycles in Incremental and Mixed modes"; 
        startDocker
        while [[ $native_cpu -lt $host_cpu ]]; do
            runDocker &
            runNative
            wait
            echo "WRF with $native_cpu CPU(s) (Native) and $docker_cpu CPU(s) (Docker) finished"
            ((native_cpu++))
            ((docker_cpu--))
        done
        stopDocker
    } || {
        read -p "How many CPUs for Docker? (Max: $((host_cpu-1))): " docker_cpu
        while ! [[ $docker_cpu =~ $re ]] || [[ $docker_cpu -gt $((host_cpu-1)) ]]; do
            echo "Invalid option, try again."
            read -p "How many CPUs for Docker? (Max: $((host_cpu-1))): " docker_cpu
        done
        native_cpu=$((host_cpu - docker_cpu))
        echo "Beginning WRF with $native_cpu CPU(s) (Native) and $docker_cpu CPU(s) (Docker) and in Single-run and Mixed modes"
        startDocker
        runDocker &
        runNative
        wait
        echo "WRF with $native_cpu CPU(s) (Native) and $docker_cpu CPU(s) (Docker) finished"
        stopDocker
    }
    j=0

elif [[ $where == "n" ]]; then 
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

else 
    read -p "How many CPUs? (Max: $host_cpu): " cpu
    while ! [[ $cpu =~ $re ]] || [[ $cpu -gt $host_cpu ]]; do
        echo "Invalid option, try again."
        echo ""
        read -p "How many CPUs? (Max: $host_cpu): " cpu
    done
    [[ $how == "i" ]] && {
        docker_cpu=1; 
        echo "Beginning WRF with $cpu cycles in Incremental and Docker modes";
        startDocker
        while [[ $docker_cpu -le $cpu ]]; do
            runDocker;
            echo "WRF with $docker_cpu CPU(s) finished"
            ((docker_cpu++))
        done
        stopDocker
    } || {
        echo "Beginning WRF with $cpu CPU(s) in Single-run and Docker modes"; 
        docker_cpu=$cpu; 
        startDocker
        runDocker;
        echo "WRF with $cpu CPU(s) finished"
        stopDocker
    }
    j=0
fi
} 2>&1 | tee -a $HOME/wrf/OOM-Internship/logs/wrf_$date.log