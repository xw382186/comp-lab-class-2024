#!/bin/bash
#SBATCH --job-name=lammps_test
#SBATCH --partition=cs    # 指定 cs 分区
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=00:30:00
mpirun lmp -in in.melt
