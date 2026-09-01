#!/bin/bash -l

#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH -A tutorial
#SBATCH -p tutorial
#SBATCH -o %j.out
#SBATCH -e %j.err
#### DO NOT CHANGE THE SCRIPT ABOVE ####
#### MAKE CHANGES FROM THIS POINT ONWARD ####
#SBATCH -J broken
#SBATCH -t 00:01:00
#SBATCH --gres=gpu:1
# You can always comment out the option like this:
# SBATCH --mem=10MB
# now the default memory is used
# what does the .err file say now?
# since this is a GPU run, what is required to run it?

ml GCC/14.2.0 GROMACS/2026.2-CUDA-12.8.0-SMP

cd $SCRATCHDIR
cp $SLURM_SUBMIT_DIR/*.tpr .

#### DO NOT CHANGE SCRIPT BELOW ####
cwd=$(pwd -P)
[[ ! "$cwd" == "$SCRATCHDIR" ]] && { echo "The calculation is not being run on scratch space. You need to correct it." 1>&2 ; exit 0 ; }

gmx mdrun -nb gpu -ntmpi 1 -ntomp $SLURM_CPUS_PER_TASK -s Crambin.tpr -nsteps 10000

cp md.log $SLURM_SUBMIT_DIR/$SLURM_JOB_NAME.log
cd $SLURM_SUBMIT_DIR
rm -r $SCRATCHDIR


