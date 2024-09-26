#!/bin/bash
#SBATCH --job-name=gromacs_gyration    # 任务名称
#SBATCH --nodes=1                      # 使用一个节点
#SBATCH --ntasks=1                     # 使用1个CPU核心
#SBATCH --time=01:00:00                # 最大运行时间1小时
#SBATCH --mem=2G                       # 内存限制2GB
#SBATCH --output=gyration_%j.out       # 标准输出文件
#SBATCH --error=gyration_%j.err        # 标准错误文件

# 加载 GROMACS 模块
module purge
module load gromacs/openmpi/intel/2023.3  # 根据需求修改GROMACS版本

# 切换到工作目录
cd /scratch/wx2237/groana  # 修改为您的工作目录

# 运行 GROMACS 回转半径分析
echo "1" | gmx_mpi gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -o gyrate.xvg
