
##SBATCH --ntasks=         
##SBATCH --cpus-per-task=    
##SBATCH --mem=1G             
##SBATCH --time=00:00:00      
#SBATCH --partition=compute
#SBATCH --account=ubuntu
  
. /GEOG/wrf/gccvars.sh
echo "Starting $SLURM_NTASKS WRF tasks on $SLURM_NNODES nodes and with $SLURM_CPUS_PER_TASK tasks p/node."
echo "WRF start: $(date +"%Y%m%d-%H%M%S")" 
timeout 3600s mpirun -np $SLURM_NTASKS /GEOG/wrf/WRF/WRF/run/wrf.exe
echo "WRF finished: $(date +"%Y%m%d-%H%M%S")"
n=0 
while [[ $n -lt $SLURM_NTASKS ]]; do
        file=$(printf "%04d" $n)
        echo ""
        echo "rsl.error.$file result (Slurm):"
        tail rsl.error.$file
        echo ""
        echo "rsl.out.$file result (Slurm):"
        tail rsl.out.$file
        ((n++))
done
echo ""
echo "Present wrfout files (Slurm):"
ls -ls wrfout*
echo ""
echo "WRF job completed."