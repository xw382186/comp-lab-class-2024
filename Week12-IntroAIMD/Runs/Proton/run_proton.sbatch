#!/bin/bash
#SBATCH --job-name=proton_aimd         # 作业名称
#SBATCH --output=proton_aimd.out       # 标准输出文件
#SBATCH --error=proton_aimd.err        # 错误输出文件
#SBATCH --time=8:00:00                # 作业最长运行时间                # 分区名称
#SBATCH --nodes=1                      # 使用的节点数量
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=12           # 每个节点使用的任务数量（核数）

# 加载 CP2K 模块
module load cp2k/openmpi/intel/20201212

# 运行 CP2K 模拟
mpirun -np 12 cp2k.popt -i proton.inp -o proton_md_sim.log
