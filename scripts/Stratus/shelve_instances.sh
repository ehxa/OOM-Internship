echo "Welcome to openStack Stratus!"
echo "This script will help you shelve your Stratus instances."
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
openstack server list -f value -c Name | xargs -P 7 -I {} openstack server shelve {}
openStack server list
echo "All instances shelved."
echo ""