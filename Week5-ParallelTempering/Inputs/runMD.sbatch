#!/bin/bash
#SBATCH --job-name=gromacs_production_md     # Job name
#SBATCH --ntasks=1                           # Use 1 CPU core
#SBATCH --time=48:00:00                      # Maximum run time (48 hours)
#SBATCH --output=gromacs_production_%j.out   # Standard output
#SBATCH --error=gromacs_production_%j.err    # Standard error

# 加载 GROMACS 模块
module load gromacs/openmpi/intel/2023.3

# 检查输入文件是否存在
if [ -f "adp.gro" ] && [ -f "adp.top" ] && [ -f "adp_T300.mdp" ]; then
    echo "Running Production MD..."
    gmx_mpi grompp -f adp_T300.mdp -c adp.gro -p adp.top -o production_md.tpr
    gmx_mpi mdrun -deffnm production_md
else
    echo "Input files for production not found!"
    exit 1
fi
