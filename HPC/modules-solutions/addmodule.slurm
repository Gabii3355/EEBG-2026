#!/bin/bash -l

#SBATCH -J add_module
#SBATCH -N 1
#SBATCH --ntasks-per-node=2
#SBATCH -t 00:05:00
#SBATCH -A tutorial
#SBATCH -p tutorial
#SBATCH -o %j.out
#SBATCH -e %j.err

### ADD THE LINE HERE ###
ml GCC/13.2.0 OpenMPI/4.1.6 GROMACS/2024.4-CUDA-12.4.0

### DO NOT CHANGE THE CODE BELOW ###
groload=$(grep "loaded\." $SLURM_JOB_ID.err | grep "GROMACS/")
[[ "x$groload" == "x" ]] && { echo "ERROR Please load one of the available modules of GROMACS above, references the HPC Handout, if you are lost" 1>&2 ; exit 0 ; }

mpiload=$(grep "loaded" $SLURM_JOB_ID.err | grep "OpenMPI/")
[[ "x$mpiload" == "x" ]] && { echo "ERROR The version of GROMACS must support MPI. Use \`hpc-modules -s gromacs\` to learn more." 1>&2 ; exit 0 ; }

version="${groload:9:4}${groload:14:1}"
[[ "$version" -lt 20240 || "$version" -gt 20250 ]] && { echo "ERROR This version is not right. Please choose a version from 2024." 1>&2 ; exit 0 ; }

cd $SCRATCHDIR
cp $SLURM_SUBMIT_DIR/*.tpr .

mpiexec --bind-to none -n $SLURM_NTASKS gmx_mpi mdrun -nb cpu -s Crambin.tpr -nsteps 3000 2>&1

cp md.log $SLURM_SUBMIT_DIR/$SLURM_JOB_NAME.log
cd $SLURM_SUBMIT_DIR
rm -r $SCRATCHDIR

