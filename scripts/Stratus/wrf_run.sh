#!/bin/bash
# Script for showing WRF start and end (date and time) for Stratus
#Author: Diogo Gouveia (ehxa)
#Version: 20250203 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

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

while [[ $where != "n" && $where != "d" && $where != "m"  ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "Where do you want to run it? Native (n), Docker (d) or Mixed (m): " where
done

if [[ $where == "n" ]]; then
    log="Native"
elif [[ $where == "d" ]]; then
    log="Docker"
else
    log="Mixed"
fi

sudo mkdir -p /LOGS/Native
sudo mkdir -p /LOGS/Docker
sudo mkdir -p /LOGS/Mixed

echo ""

printNative () {
    n=0 # count variable to print all rsl.out files
    while [[ $n -lt $native_cpu ]]; do
        file=$(printf "%04d" $n)
        echo ""
        echo "rsl.error.$file result (Native):"
        tail rsl.error.$file
        echo ""
        echo "rsl.out.$file result (Native):"
        tail rsl.out.$file
        ((n++))
    done
    echo ""
    echo "Present wrfout files (Native):"
    ls -ls wrfout*
    echo ""
    rm -rf rsl* && rm -rf wrfout*
}

printDocker () {
    n=0 #count variable to print all rsl.out files
    while [[ $n -lt $docker_cpu ]]; do
        file=$(printf "%04d" $n)
        echo ""
        echo "rsl.error.$file result (Docker):"
        sudo docker exec -i ubuntu24.04-wrf-gcc bash -c "tail /home/swe/wrf/WRF/WRF/$location/rsl.error.$file"
        echo ""
        echo "rsl.out.$file result (Docker):"
        sudo docker exec -i ubuntu24.04-wrf-gcc bash -c "tail /home/swe/wrf/WRF/WRF/$location/rsl.out.$file"
        ((n++))
    done
    echo ""
    echo "Present wrfout files (Docker):"
    sudo docker exec -i ubuntu24.04-wrf-gcc bash -c "ls -ls /home/swe/wrf/WRF/WRF/$location/wrfout*"
    echo ""
    sudo docker exec -i ubuntu24.04-wrf-gcc bash -c "rm -rf /home/swe/wrf/WRF/WRF/$location/rsl* /home/swe/wrf/WRF/WRF/$location/wrfout*"
}

runDocker () {
    sudo docker start ubuntu24.04-wrf-gcc;
    echo "WRF with $docker_cpu CPU(s) started in Docker"
    echo "Start (Docker): $(date)"
    if [[ $which == "r" ]]; then
        sudo docker exec -i ubuntu24.04-wrf-gcc bash -c ". /home/swe/wrf/gccvars.sh && cd /home/swe/wrf/WRF/WRF/$location && timeout 3600s mpirun -np $docker_cpu ./wrf.exe;"
    else
        sudo docker exec -i ubuntu24.04-wrf-gcc bash -c ". /home/swe/wrf/gccvars.sh && cd /home/swe/wrf/WRF/WRF/$location && mpirun -np $docker_cpu ./wrf.exe;"
    fi
    echo "Finish (Docker): $(date)"
    printDocker
    sudo docker stop ubuntu24.04-wrf-gcc;
}

startDocker () {
    if [[ $j -eq 1 ]]; then
        sudo systemctl start docker; 
        sleep 20;
    fi
}

stopDocker () {
    sudo systemctl stop docker; 
    sudo systemctl stop docker.socket;
}

runNative () {
    echo "WRF with $native_cpu CPU(s) started natively"
    echo "Start (Native): $(date)"
    if [[ $which == "r" ]]; then
        . $HOME/wrf/gccvars.sh && cd $HOME/wrf/WRF/WRF/$location &&  timeout 3600s mpirun -np $native_cpu ./wrf.exe;
    else
        . $HOME/wrf/gccvars.sh && cd $HOME/wrf/WRF/WRF/$location && mpirun -np $native_cpu ./wrf.exe;
    fi
    echo "Finish (Native): $(date)"
    printNative
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
} 2>&1 | sudo tee -a /LOGS/$log/wrf_$date.log