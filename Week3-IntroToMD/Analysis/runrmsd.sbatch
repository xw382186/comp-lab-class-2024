#!/bin/bash
#SBATCH --job-name=gromacs_rms_job      # 任务名称
#SBATCH --partition=cs                  # 分区 (根据集群实际分区调整)
#SBATCH --nodes=1                       # 使用一个节点
#SBATCH --ntasks=1                      # 使用8个CPU核心
#SBATCH --time=02:00:00                 # 设置最大运行时间2小时
#SBATCH --mem=16G                       # 请求16GB内存
#SBATCH --output=gromacs_rms_%j.out     # 标准输出文件
#SBATCH --error=gromacs_rms_%j.err      # 标准错误文件
#SBATCH --mail-type=END                 # 当任务结束时发送邮件
#SBATCH --mail-user=your.email@domain.com # 您的邮箱地址

# 加载 GROMACS 模块
module purge
module load gromacs/openmpi/intel/2023.3  # 加载GROMACS的2023.3版本

# 切换到工作目录
cd /scratch/wx2237/groana

# 1. 使用 trjconv 去除PBC并将蛋白质居中
echo "1 0" | gmx_mpi trjconv -s md_0_1.tpr \
                             -f md_0_1.xtc \
                             -o md_0_1_noPBC.xtc \
                             -pbc mol -center

# 2. 计算与模拟中的参考结构的 RMSD
echo "4 4" | gmx_mpi rms -s md_0_1.tpr \
                         -f md_0_1_noPBC.xtc \
                         -o rmsd.xvg -tu ns

# 3. 计算与晶体结构的 RMSD
echo "4 4" | gmx_mpi rms -s em.tpr \
                         -f md_0_1_noPBC.xtc \
                         -o rmsd_xtal.xvg -tu ns
