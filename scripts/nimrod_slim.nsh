#!/sw7/RCC/NimrodG/embedded-1.9.0/bin/nimexec

#Fix up Account String
#PBS -A UQ-SCI-BiolSci
#10 nodes, 24 cores, 120GB per node
#PBS -l select=10:ncpus=24:mem=120GB:ompthreads=1 
#PBS -l walltime=336:00:00
#PBS -N NIM_EG

# There are additional directives for Nimrod to interpret with #NIM at the start of each line.
# Tell Nimrod to use this as the shell for the job proper when it has parsed this file.
#NIM shebang /bin/bash

COMBO_ROWS=256
SEED_ROWS=50

# =============================================================================
# Tell Nimrod what range of parameter values you want to use 
# =============================================================================

#The parameters for the latin squares are rows in the input file.
#NIM parameter LS integer range from 1 to ${COMBO_ROWS} step 1

#Repeat 50 times for each hypercube with a different SEED value
#NIM parameter SEED integer range from 1 to ${SEED_ROWS} step 1


# Just checking that something did not go wrong with assignment of the J values.
if [ -z "${NIMROD_VAR_LS}" ]; then
        echo "\$NIMROD_VAR_LS isn't set, cannot continue..." 
        exit 2
fi

if [ -z "${NIMROD_VAR_SEED}" ]; then
        echo "\$NIMROD_VAR_SEED isn't set, cannot continue..." 
        exit 2
fi

#Where you submit this job from will be the value of $PBS_O_WORKDIR
echo "PBS_O_WORKDIR is ${PBS_O_WORKDIR}" 
#Everything you need should be located relative to PBS_O_WORKDIR, or else a full path
#Set the cd to TMPDIR for writing SLiM output
cd ${TMPDIR}

#=====================
#Modify these to suit.
#=====================

# Always run the entire parameter range cause nimrod can do them in any order.
# See the -f test below about skipping the ones we have already done.
RUNNAME="example_slim_job" 

OUTFILE="${PBS_O_WORKDIR}/Outputs/TEST_${NIMROD_VAR_LS}_${NIMROD_VAR_SEED}.txt" 
echo "${OUTFILE}" 

if [ -f ${OUTFILE} ]; then
  echo "Output file ${OUTFILE} already exists. Skipping this index value ${NIMROD_VAR_LS} ${NIMROD_VAR_SEED}" 
  exit 0
fi

mkdir -p ./matrices/model${NIMROD_VAR_LS}

RSCRIPTNAME="${PBS_O_WORKDIR}/R/${RUNNAME}.R" 

module purge
module load R/4.1.0+SLiM

Rscript $RSCRIPTNAME ${NIMROD_VAR_SEED} ${NIMROD_VAR_LS}

cat /${TMPDIR}/output_${NIMROD_VAR_SEED}_${NIMROD_VAR_LS}.csv >> /scratch/${USER}/

touch ${OUTFILE} 

