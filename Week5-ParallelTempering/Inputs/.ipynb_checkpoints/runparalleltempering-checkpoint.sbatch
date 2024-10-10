#!/bin/bash
#SBATCH --job-name=parallel_tempering      # Job name
#SBATCH --nodes=1                          # Use 1 node
#SBATCH --ntasks=3                         # 3 tasks, one for each temperature
#SBATCH --cpus-per-task=1                  # Assign 1 CPU per task
#SBATCH --time=1:00:00                    # Maximum run time (24 hours)
#SBATCH --mem=4G  # 每个任务分配 4 GB 内存
#SBATCH --output=parallel_tempering_%j.out # Standard output
#SBATCH --error=parallel_tempering_%j.err  # Standard error


# 加载 GROMACS 模块
module load gromacs/openmpi/intel/2023.3

# 定义输入文件和目录
INPUT_GRO="adp.gro"
INPUT_TOP="adp.top"
NVT_MDP_300="nvt_300.mdp"
NVT_MDP_400="nvt_400.mdp"
NVT_MDP_600="nvt_600.mdp"

# Step 1: 创建目录 T300, T400, T600 并生成 .tpr 文件
mkdir -p T300 T400 T600

# 生成每个温度的 .tpr 文件
gmx_mpi grompp -f $NVT_MDP_300 -c $INPUT_GRO -p $INPUT_TOP -o T300/adp.tpr
gmx_mpi grompp -f $NVT_MDP_400 -c $INPUT_GRO -p $INPUT_TOP -o T400/adp.tpr
gmx_mpi grompp -f $NVT_MDP_600 -c $INPUT_GRO -p $INPUT_TOP -o T600/adp.tpr

# Step 2: 运行并行回火模拟 (5 ns，每隔 1000 fs 尝试交换)
# 每个任务将使用 1 个 CPU 核心
mpirun -np 3 gmx_mpi mdrun -s adp -multidir T300/ T400/ T600/ -deffnm adp_exchange3temps -replex 500 -ntomp 1

# Step 3: 计算每个复制品的能量并生成直方图数据
gmx_mpi energy -f T300/adp_exchange3temps.edr -o energy_300.xvg << EOF
10 0
EOF

gmx_mpi energy -f T400/adp_exchange3temps.edr -o energy_400.xvg << EOF
10 0
EOF

gmx_mpi energy -f T600/adp_exchange3temps.edr -o energy_600.xvg << EOF
10 0
EOF

# Step 4: 使用 demux.pl 脚本分析日志文件并生成 replica_index.xvg 和 replica_temp.xvg
demux.pl T300/adp_exchange3temps.log
