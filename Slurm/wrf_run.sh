#!/bin/bash
date=$(date +"%Y%m%d-%H%M%S")
echo "Welcome to WRF!"
echo ""
read -p "How many tasks? " tasks
read -p "How many nodes? " nodes
read -p "How many tasks p/node?  " tasks_p_node

echo ""
{
    sbatch --nodes=$nodes --ntasks=$tasks --nodes=$nodes --cpus-per-task=$tasks_p_node /GEOG/wrf_sbatch.sh
} 2>&1 | sudo tee -a /LOGS/Slurm/wrf_$date.log
