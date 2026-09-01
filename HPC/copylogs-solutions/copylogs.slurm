#!/bin/bash -l

#SBATCH -J copylogs
#SBATCH -N 1
#SBATCH --ntasks-per-node=2
#SBATCH -t 00:05:00
#SBATCH -A tutorial
#SBATCH -p tutorial
#SBATCH -o %j.out
#SBATCH -e %j.err

ml GCC/14.2.0 OpenMPI/5.0.7 GROMACS/2026.2-CUDA-12.8.0

cd $SCRATCHDIR
cp $SLURM_SUBMIT_DIR/*.tpr .

mpiexec --bind-to none -n $SLURM_NTASKS gmx_mpi mdrun -nb cpu -s Crambin.tpr -nsteps 3000

### DO NOT CHANGE ANYTHING ABOVE ###
### MAKE YOUR CHANGES FROM THIS POINT ONWARD ###
cp md.log $SLURM_SUBMIT_DIR/.
