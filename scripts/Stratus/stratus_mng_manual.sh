project=$(pwd)
credentials="numeric-model-openrc.sh"
venv="stratus-venv"
echo "Welcome to openStack Stratus!"
echo "This script will help you unshelve your Slurm cluster."
cd $project
ls
echo ""
source $credentials
echo ""
source $venv/bin/activate
echo ""