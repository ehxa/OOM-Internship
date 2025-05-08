# How to use and configure Kubernetes for running WRF (Single master pod and dual-worker pod configuration)

## 1. Create storage for running WRF and for input data
a. kubectl apply -f wrf-pv.yaml #Note: Make sure to change the path variable in this YAML for a actual shared directory\
b. kubectl apply -f wrf-pvc.yaml

## 2. Create the services for inter-pod comnunication
a. kubectl apply -f wrf-master-service.yaml\
b. kubectl apply -f wrf-worker0-service.yaml\
c. kubectl apply -f wrf-worker1-service.yaml\
d. kubectl apply -f wrf-master.yaml\
e. kubectl apply -f wrf-worker0.yaml\
f. kubectl apply -f wrf-worker1.yaml\
g. Wait for about 30 seconds

## 3. Configure ssh access to the other pods in wrf-worker0:
a. kubectl logs wrf-master\
b. kubectl logs wrf-worker1\
c. echo "wrf-master RSA public key" >> /home/swe/.ssh/authorized_keys\
d. echo "wrf-worker1 RSA public key" >> /home/swe/.ssh/authorized_keys\
e. ssh swe@wrf-worker1 #Say yes\
f. exit

## 4. Configure ssh access to the other pods in wrf-worker1:
a. kubectl logs wrf-master\
b. kubectl logs wrf-worker0\
c. echo "wrf-master RSA public key" >> /home/swe/.ssh/authorized_keys\
d. echo "wrf-worker0 RSA public key" >> /home/swe/.ssh/authorized_keys\
e. ssh swe@wrf-worker0 #Say yes\
f. exit

## 5. Copy hosts.txt to the directory used in 1.a.

## 6. Run WRF:
a. ./wrf_run_host.sh #Change -np X, where X is the number of tasks
