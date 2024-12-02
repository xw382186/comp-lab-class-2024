#!/bin/bash
#SBATCH --job-name=water_aimd
#SBATCH --output=water_aimd.out
#SBATCH --error=water_aimd.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --mem=20GB
#SBATCH --time=6:00:00

module load cp2k/openmpi/intel/20201212
mpirun -np 12 cp2k.popt -i water.inp -o water_aimd.log
