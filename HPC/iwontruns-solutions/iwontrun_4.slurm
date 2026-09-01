#!/bin/bash -l

#SBATCH -J hello_training_world
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -t 00:05:00
#SBATCH -A tutorial
#SBATCH -p tutorial
#SBATCH --mem=1GB

sleep 10s
echo "Hello world"
