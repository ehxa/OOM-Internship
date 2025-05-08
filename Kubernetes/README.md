# How to use and configure Kubernetes for running WRF (Single master pod and dual-worker pod configuration)

## 1. Create storage for running WRF and for input data
a. kubectl apply -f wrf-arm-pv.yaml #Note: Make sure to change the path variable in this YAML for a actual share directory\
b. kubectl apply -f wrf-arm-pvc.yaml

## 2. Create the services for inter-pod comnunication
a. kubectl apply -f wrf-arm-master-service.yaml\
b. kubectl apply -f wrf-arm-worker0-service.yaml\
c. kubectl apply -f wrf-arm-worker1-service.yaml\
d. kubectl apply -f wrf-arm-master.yaml\
e. kubectl apply -f wrf-arm-worker0.yaml\
f. kubectl apply -f wrf-arm-worker1.yaml\
g. Wait for about 30 seconds

## 3. Configure ssh access to the other pods in wrf-arm-worker0:
a. kubectl logs wrf-arm-master\
b. kubectl logs wrf-worker1\
c. echo "wrf-arm-master RSA public key" >> /home/swe/.ssh/authorized_keys\
d. echo "wrf-arm-worker1 RSA public key" >> /home/swe/.ssh/authorized_keys\
e. ssh swe@wrf-arm-worker1 #Say yes\
f. exit

## 4. Configure ssh access to the other pods in wrf-arm-worker0:
a. kubectl logs wrf-arm-master\
b. kubectl logs wrf-worker0\
c. echo "wrf-arm-master RSA public key" >> /home/swe/.ssh/authorized_keys\
d. echo "wrf-arm-worker0 RSA public key" >> /home/swe/.ssh/authorized_keys\
e. ssh swe@wrf-arm-worker0 #Say yes\
f. exit

## 5. Copy hosts.txt to the directory used in 1.a.

## 6. Run WRF:
a. ./wrf_run_host.sh #Change -np X, where X is the number of tasks
