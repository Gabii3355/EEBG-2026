#!/bin/bash -l

#SBATCH -J hello_training_world
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -t 00:01:00
#SBATCH -A tutorial
#SBATCH -p tutorial

sleep 10s
echo "Hello world"
