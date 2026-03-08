#!/bin/bash
#$ -N test_nextflow_controller
#$ -cwd
#$ -l h_rt=24:00:00
#$ -l h_vmem=8G
#$ -pe smp 2
#$ -o /broad/thechenlab/ClaudiaC/UGER/logs/$JOB_NAME.$JOB_ID.out
#$ -e /broad/thechenlab/ClaudiaC/UGER/logs/$JOB_NAME.$JOB_ID.err
#$ -M cchu@broadinstitute.org
#$ -m bea

CONDA_ENV="/broad/thechenlab/ClaudiaC/envs_UGER/bj_nextflow_env"
NEXTFLOW_DIR="/home/unix/cchu/projects/bj-wgs"
SENTIEON_LIC="/mnt/thechenlab/ClaudiaC/packages/sentieon_key_exp_2026-06-30/Broad_Institute_Of_MIT_And_Harvard__Harvard_University_eval.lic"
PUBLISH_DIR="/mnt/thechenlab/ClaudiaC/dGT_analysis/results/2026-03-07_BJ_WGS_DNA_test"

# ── Environment ───────────────────────────────────────────────────────────────
set +u
export SHELL=/bin/bash
source /broad/software/scripts/useuse
reuse -q Anaconda3
reuse -q UGER

source activate "${CONDA_ENV}"

cd "${NEXTFLOW_DIR}"

echo "Running nextflow pipeline..."
nextflow run main.nf \
    -profile uger \
    --input_csv "$PWD/tests/data/inputs/input.csv" \
    --publish_dir "${PUBLISH_DIR}" \
    --sentieon_license "${SENTIEON_LIC}" \
    --max_cpus 8 \
    --max_memory 50.GB

echo "Pipeline completed"
