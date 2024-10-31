#!/bin/bash
#SBATCH --job-name=3dWCA_simulations   # 任务名称
#SBATCH --output=3dWCA_%j.out          # 输出文件名，%j 会自动替换为jobID
#SBATCH --error=3dWCA_%j.err           # 错误日志文件
#SBATCH --time=12:00:00                # 任务运行时间上限
#SBATCH --nodes=1                      # 节点数量
#SBATCH --ntasks=1                     # 任务数量（即每个模拟用一个核心）
#SBATCH --mem=2GB                      # 每个任务使用的内存
#SBATCH --partition=cs                 # 使用的分区

# 加载 LAMMPS 环境
source /scratch/work/courses/CHEM-GA-2671-2024fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

# 密度范围从 0.8 到 1.5
for density in 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5
do
    # 运行 LAMMPS，传递变量并将日志保存为相应的文件
    mpirun lmp -var density $density -in /scratch/wx2237/comp-lab-class/comp-lab-class-2024/Week8-LAMMPS-crystallization/Inputs/3dWCA.in > log_3d_density_${density}.log
done
