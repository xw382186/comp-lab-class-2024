#!/bin/bash
#SBATCH --job-name=KALJ_cooling
#SBATCH --output=kalj_cooling_%j.out
#SBATCH --error=kalj_cooling_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --partition=cs
#SBATCH --time=02:00:00

# 加载LAMMPS环境
source /scratch/work/courses/CHEM-GA-2671-2024fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

# 创建Data目录
mkdir -p /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week9-LAMMPS-SupercooledLiquids/Data
cd /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week9-LAMMPS-SupercooledLiquids/Data

# 复制必要的输入文件
cp /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week9-LAMMPS-SupercooledLiquids/Inputs/kalj.lmp .
cp /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week9-LAMMPS-SupercooledLiquids/Inputs/kalj_particles.lmp .

# 创建系统
mpirun lmp -var configfile ../Inputs/n360/kalj_n360_create.lmp -var id 1 -in ../Inputs/create_3d_binary.lmp

# 循环冷却系统至不同温度
for temp in 1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475; do
    mpirun lmp -var configfile ../Inputs/n360/kalj_n360_T${temp}.lmp -var id 1 -in ../Inputs/anneal_3d_binary.lmp
done
