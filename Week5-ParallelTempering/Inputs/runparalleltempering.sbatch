#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH -p g-3080-1x
#SBATCH --job-name=gromacs_parallel_tempering
#SBATCH --nodes=1                      # Request 1 node
#SBATCH --ntasks=3                     # Request 3 tasks (one for each simulation)
#SBATCH --cpus-per-task=1               # Use 1 CPU core per task
#SBATCH --time=1:00:00                 # Set a time limit (adjust if necessary)
#SBATCH --output=gromacs_parallel_tempering_%j.out
#SBATCH --error=gromacs_parallel_tempering_%j.err

# Clear all loaded modules
module purge

# Load necessary modules
module load GROMACS/2021.3-foss-2021a-CUDA-11.3.1-PLUMED-2.7.2 # Load GROMACS with PLUMED and OpenMPI support

# Define input files and directories
input_gro="adp.gro"
input_top="adp.top"
nvt_mdp_300="nvt_300.mdp"
nvt_mdp_400="nvt_400.mdp"
nvt_mdp_600="nvt_600.mdp"

# Step 1: Create directories and generate .tpr files if not already created
mkdir -p T300 T400 T600

# Generate .tpr files for each temperature (skip if already done)
gmx_mpi grompp -f $nvt_mdp_300 -c $input_gro -p $input_top -o T300/adp.tpr
gmx_mpi grompp -f $nvt_mdp_400 -c $input_gro -p $input_top -o T400/adp.tpr
gmx_mpi grompp -f $nvt_mdp_600 -c $input_gro -p $input_top -o T600/adp.tpr

# Step 2: Run parallel tempering simulation with 5 ns runtime and exchange every 1000 fs
mpirun -np 3 gmx_mpi mdrun -s adp -multidir T300/ T400/ T600/ -deffnm adp_exchange3temps -replex 500
