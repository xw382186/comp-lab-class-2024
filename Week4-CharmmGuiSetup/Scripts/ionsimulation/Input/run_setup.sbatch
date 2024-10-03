#!/bin/bash
#SBATCH --job-name=ion_water_simulation
#SBATCH --ntasks-per-node=10
#SBATCH --cpus-per-task=1
#SBATCH --time=4:00:00
#SBATCH --mem=8G
#SBATCH --output=ion_water_simulation.out
#SBATCH --error=ion_water_simulation.err

# Load Gromacs module
module purge
module load gromacs/openmpi/intel/2023.3

# Set up input files and steps
init=step3_input
mini_prefix=step4.0_minimization
equi_prefix=step4.1_equilibration
prod_prefix=step5_production
prod_step=step5

# Minimization step
srun -n 1 gmx_mpi grompp -f ${mini_prefix}.mdp -o ${mini_prefix}.tpr -c ${init}.gro -r ${init}.gro -p topol.top -n index.ndx -maxwarn 2
srun gmx_mpi mdrun -v -deffnm ${mini_prefix}

# Equilibration step
srun -n 1 gmx_mpi grompp -f ${equi_prefix}.mdp -o ${equi_prefix}.tpr -c ${mini_prefix}.gro -r ${init}.gro -p topol.top -n index.ndx -maxwarn 2
srun gmx_mpi mdrun -v -deffnm ${equi_prefix}

# Production run for 10 steps
cnt=1
cntmax=10

while [ ${cnt} -le ${cntmax} ]
do
    pcnt=$((${cnt}-1))
    istep=${prod_step}_${cnt}
    pstep=${prod_step}_${pcnt}

    if [ ${cnt} -eq 1 ]; then
        pstep=${equi_prefix}
    fi

    srun gmx_mpi grompp -f ${prod_prefix}.mdp -o ${istep}.tpr -c ${pstep}.gro -p topol.top -n index.ndx
    srun gmx_mpi mdrun -v -deffnm ${istep}

    cnt=$((${cnt}+1))
done
