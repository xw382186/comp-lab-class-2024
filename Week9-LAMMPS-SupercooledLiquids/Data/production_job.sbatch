#!/bin/bash
#SBATCH --job-name=KALJ_production
#SBATCH --output=kalj_production_%j.out
#SBATCH --error=kalj_production_%j.err
#SBATCH --nodes=1
#SBATCH --mem=8G  # 请求8GB内存（根据你的需求调整）
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --partition=cs
#SBATCH --time=01:30:00  # 根据模拟需要调整时间

# 加载LAMMPS环境
source /scratch/work/courses/CHEM-GA-2671-2024fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

# 进入Data目录
cd /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week9-LAMMPS-SupercooledLiquids/Data

# 循环生产模拟
for temp in 1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475; do
    mpirun lmp -var configfile ../Inputs/n360/kalj_n360_T${temp}.lmp -var id 1 -in ../Inputs/production_3d_binary.lmp
done
