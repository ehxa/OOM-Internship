#!/bin/bash
# Script for showing WRF start and end (date and time) for Stratus
#Author: Diogo Gouveia (ehxa)
#Version: 20250218 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

echo "Welcome to WRF!"
echo ""
re='^[0-9]+$'
host_cpu=$(nproc)
date=$(date +"%Y%m%d-%H%M%S")

read -p "Which location do you want to run it? em_real [e] or run [r]: " which

while [[ $which != "e" && $which != "r" ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "Which location do you want to run it? em_real [e] or run [r]: " which
done

if [[ $which == "e" ]]; then
    location="test/em_real"
else
    location="run"
fi

read -p "How do you want to run it? Single-run [s], Incrementally [i], or Repeated [r]: " how

while [[ $how != "i" && $how != "s" && $how != "r" ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "How do you want to run it? Single-run [s], Incrementally [i], or Repeated [r]: " how
done

read -p "Where do you want to run it? Native [n], Docker [d], or Kubernetes [k]: " where

while [[ $where != "n" && $where != "d" && $where != "k" ]]; do
    echo "Invalid option, try again."
    echo ""
    read -p "Where do you want to run it? Native [n], Docker [d],or Kubernetes [k]: " where
done

if [[ $where == "n" ]]; then
    log="Native"
elif [[ $where == "d" ]]; then
    log="Docker"
else
    log="Kubernetes"
fi

sudo mkdir -p /LOGS/Native
sudo mkdir -p /LOGS/Docker
sudo mkdir -p /LOGS/Kubernetes

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
}

printDocker () {
    n=0 
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

runKubernetes () {
    mkdir -p $HOME/wrf-k8s
    cd $HOME/wrf-k8s
    if [[ $which == "r" ]]; then
        sudo k8s kubectl apply -f wrf_run.yaml
    else
        sudo k8s kubectl apply -f wrf_emreal.yaml
    fi
    sleep 30
    echo "WRF with $k8s_cpu CPU(s) started in Kubernetes"
    echo "Start (Kubernetes): $(date)"
    sudo k8s kubectl logs -f job/wrf-k8s
    echo "Finish (Kubernetes): $(date)"
    sudo k8s kubectl delete job wrf-k8s
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
    sudo systemctl start docker; 
    sleep 20;
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

if [[ $where == "n" ]]; then 
    read -p "How many CPUs? (Max: $host_cpu): " cpu
    while ! [[ $cpu =~ $re ]] || [[ $cpu -gt $host_cpu ]]; do
        echo "Invalid option, try again."
        echo ""
        read -p "How many CPUs? (Max: $host_cpu): " cpu
    done
    if [[ $how == "i" ]]; then
        native_cpu=1
        echo "Beginning WRF with $cpu cycles in Incremental and Native modes"
        while [[ $native_cpu -le $cpu ]]; do
            runNative
            echo "WRF with $native_cpu CPU(s) finished"
            ((native_cpu++))
        done
    elif [[ $how == "s" ]]; then
        native_cpu=$cpu
        echo "Beginning WRF with $cpu CPU(s) in Single-run and Native modes"
        runNative
        echo "WRF with $cpu CPU(s) finished"
    else
        native_cpu=$cpu
        echo "Beginning WRF with $cpu CPU(s) in Repeated and Native modes"
        count=0
        while [[ $count -lt 3 ]]; do
            runNative
            ((count++))
        done
        echo "WRF with $cpu CPU(s) finished"
fi

elif [[ $where == "d" ]]; then
    read -p "How many CPUs? (Max: $host_cpu): " cpu
    while ! [[ $cpu =~ $re ]] || [[ $cpu -gt $host_cpu ]]; do
        echo "Invalid option, try again."
        echo ""
        read -p "How many CPUs? (Max: $host_cpu): " cpu
    done
    if [[ $how == "i" ]]; then
        docker_cpu=1
        echo "Beginning WRF with $cpu cycles in Incremental and Docker modes"
        startDocker
        while [[ $docker_cpu -le $cpu ]]; do
            runDocker
            echo "WRF with $docker_cpu CPU(s) finished"
            ((docker_cpu++))
        done
        stopDocker
    elif [[ $how == "s" ]]; then
        docker_cpu=$cpu
        echo "Beginning WRF with $cpu CPU(s) in Single-run and Docker modes"
        startDocker
        runDocker
        echo "WRF with $cpu CPU(s) finished"
        stopDocker
    else 
        docker_cpu=$cpu
        echo "Beginning WRF with $cpu CPU(s) in Repeated and Docker modes"
        startDocker
        count=0
        while [[ $count -lt 3 ]]; do
            runDocker
            ((count++))
        done
        echo "WRF with $cpu CPU(s) finished"
        stopDocker
    fi

else
    read -p "How many CPUs? (Max: $host_cpu): " cpu
    while ! [[ $cpu =~ $re ]] || [[ $cpu -gt $host_cpu ]]; do
        echo "Invalid option, try again."
        echo ""
        read -p "How many CPUs? (Max: $host_cpu): " cpu
    done
    if [[ $how == "i" ]]; then
        k8s_cpu=1; 
        echo "Beginning WRF with $cpu cycles in Incremental and Kubernetes modes"; 
        runKubernetes
    elif [[ $how == "s" ]]; then
        k8s_cpu=$cpu; 
        echo "Beginning WRF with $cpu CPU(s) in Single-run and Kubernetes modes"; 
        runKubernetes
    else
        k8s_cpu=$cpu; 
        echo "Beginning WRF with $cpu CPU(s) in Repeated and Kubernetes modes"; 
        count=0;
        while [[ $count -lt 3 ]]; do
            runKubernetes
            ((count++))
        done
    fi

fi
} 2>&1 | sudo tee -a /LOGS/$log/wrf_$date.log