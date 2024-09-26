#!/bin/bash
#SBATCH --job-name=gromacs_pipeline     # Job name
#SBATCH --nodes=1                       # Use one node
#SBATCH --ntasks=48                     # Total tasks (cores)
#SBATCH --time=26:00:00                 # Maximum run time (20 hours)
#SBATCH --output=gromacs_pipeline_%j.out # Standard output
#SBATCH --error=gromacs_pipeline_%j.err  # Standard error
#SBATCH -p xhhgnormal

# Load GROMACS module
module purge
#module load gromacs/openmpi/intel/2020.4  # Modify if necessary
module add gromacs/2021.3-gcc-hpcx-cuda-11.4

# Change to the working directory
cd /home/wx2237/comp-lab-class/comp-lab-class-2024/Week3-IntroToMD/Input

# 1. Energy Minimization (EM)
gmx_mpi grompp -f minim.mdp -c 2JOF_solv_ions.gro -p topol.top -o em.tpr
gmx_mpi mdrun -v -deffnm em

# 2. NVT Equilibration
gmx_mpi grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx_mpi mdrun -v -deffnm nvt

# 3. NPT Equilibration
gmx_mpi grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx_mpi mdrun -v -deffnm npt

# 4. Production MD Simulation
gmx_mpi grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
gmx_mpi mdrun -v -deffnm md_0_1
