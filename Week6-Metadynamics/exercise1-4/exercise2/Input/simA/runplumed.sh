#!/bin/bash
#SBATCH --job-name=gmx_metadynamics        # 作业名
#SBATCH --output=gmx_output_%j.log         # 标准输出日志文件（%j将被作业ID替换）
#SBATCH --error=gmx_error_%j.log           # 错误输出日志文件
#SBATCH --time=3:00:00                    # 运行时间上限 (例如 48小时)
#SBATCH --nodes=1                          # 需要的节点数
#SBATCH --ntasks=1                         # 任务数（一般是MPI进程数）
#SBATCH --cpus-per-task=16                  # 每个任务使用的CPU核心数
#SBATCH --partition=cs                     # 作业提交到的分区名称

# 加载 GROMACS 和 PLUMED 环境
source /scratch/work/courses/CHEM-GA-2671-2024fa/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules

# 运行GROMACS与PLUMED模拟
gmx_mpi mdrun -s topolA.tpr -nsteps 10000000 -plumed plumed.dat
