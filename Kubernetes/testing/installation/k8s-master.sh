sudo snap install k8s --channel= 1.32-classic/stable --classic
sudo k8s bootstrap
sudo k8s status
sudo k8s kubectl get all --all-namespaces