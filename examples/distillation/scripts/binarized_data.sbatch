#!/bin/bash

#SBATCH --job-name=binarize_data_distil
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB
#SBATCH --time=24:00:00
#SBATCH --gres=gpu:0
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=mt4493@nyu.edu
#SBATCH --output=slurm_binarize_data_distil-%j.out

COUNTRY_CODE=$1
DATA_FOLDER=$2
TOKENIZER_TYPE=$3
TOKENIZER_NAME=$4



DATA_PATH=/scratch/mt4493/twitter_labor/twitter_labor_data/data/pretraining/${COUNTRY_CODE}
CODE_PATH=/scratch/mt4493/twitter_labor/code/repos_annexe/transformers/examples/distillation/scripts
DUMP_PATH=${DATA_PATH}/distillation

mkdir -p ${DUMP_PATH}
python3 ${CODE_PATH}/binarized_data.py \
--file_path ${DATA_PATH}/ \
--tokenizer_type ${TOKENIZER_TYPE}\
--tokenizer_name ${TOKENIZER_NAME}\
--dump_file ${DUMP_PATH}/dump