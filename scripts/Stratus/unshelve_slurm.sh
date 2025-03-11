echo "Welcome to openStack Stratus!"
echo "This script will help you unshelve your Stratus cluster."
echo ""
read -p "Please enter your project folder: " project
cd $project
ls
echo ""
read -p "Please enter the name of your OpenStack credentials file: " credentials
source $credentials
echo ""
read -p "Please enter the name of Python virtual environment to use: " venv
source $venv/bin/activate
echo ""
openStack server unshelve slurm-worker2 slurm-worker1 slurm-controller
openStack server list
echo "OpenStack Slurm cluster is ready to use."
echo ""