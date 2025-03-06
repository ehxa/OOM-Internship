#!/bin/bash
export tasks=4
export nodes=2
export tasks_p_node=2

#SBATCH --job-name=wrf_run
#SBATCH --output=/LOGS/Slurm/wrf_$j.txt
#SBATCH --nodes=$nodes
#SBATCH --ntasks=$tasks
#SBATCH --ntasks-per-node=tasks_p_node         
##SBATCH --cpus-per-task=2    
##SBATCH --mem=1G             
##SBATCH --time=00:00:00      
#SBATCH --partition=compute
#SBATCH --account=ubuntu

. /GEOG/wrf/gccvars.sh
{
echo "Starting $tasks WRF tasks on $nodes nodes and with $tasks_p_node tasks p/node."
echo "WRF start: $(date +"%Y/%m/%d %H:%M:%S")"
cd /GEOG/wrf/WRF/WRF/run
timeout 3600s srun --nodes=$nodes --ntasks=$tasks --ntasks-per-node=$tasks_p_node ./wrf.exe
echo "WRF finished: $(date +"%Y/%m/%d %H:%M:%S")"
n=0 
while [[ $n -lt $tasks ]]; do
	file=$(printf "%04d" $n)
        echo ""
        echo "rsl.error.$file result (Slurm):"
        tail -25 rsl.error.$file
        echo ""
        echo "rsl.out.$file result (Slurm):"
        tail -25 rsl.out.$file
        ((n++))
done
echo ""
echo "Present wrfout files (Slurm):"
ls -ls wrfout*
echo ""
echo "WRF job completed." 
} 2>&1 | sudo tee -a /LOGS/Slurm/wrf_$(date +"%Y%m%d-%H%M%S").log 