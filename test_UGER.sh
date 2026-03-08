#!/bin/bash
#$ -N test_nextflow_controller
#$ -cwd
#$ -l h_rt=24:00:00      # controller just submits/monitors jobs; 24h covers large batches
#$ -l h_vmem=8G
#$ -pe smp 8
#$ -o /broad/thechenlab/ClaudiaC/UGER/logs/$JOB_NAME.$JOB_ID.out
#$ -e /broad/thechenlab/ClaudiaC/UGER/logs/$JOB_NAME.$JOB_ID.err
#$ -M cchu@broadinstitute.org
#$ -m bea

CONDA_ENV="/broad/thechenlab/ClaudiaC/envs_UGER/bj_nextflow_env"
NEXTFLOW_DIR="/home/unix/cchu/bj-wgs"

# ── Environment ───────────────────────────────────────────────────────────────
set +u
export SHELL=/bin/bash
source /broad/software/scripts/useuse
reuse -q Anaconda3
reuse -q UGER 

source activate "${CONDA_ENV}"

cd "${NEXTFLOW_DIR}"

echo "Running nextflow pipeline..."

nextflow run main.nf --input_csv $PWD/tests/data/inputs/input.csv -profile singularity -c conf/uger.config --publish_dir results/bj-wgs --max_cpus 8 --max_memory 50.GB
u
echo "Pipeline completed"

