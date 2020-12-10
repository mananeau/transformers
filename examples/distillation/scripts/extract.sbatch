#!/bin/bash

#SBATCH --job-name=extract_distil
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB
#SBATCH --time=24:00:00
#SBATCH --gres=gpu:0
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=mt4493@nyu.edu
#SBATCH --output=slurm_extract_distil-%j.out

COUNTRY_CODE=$1
MODEL_TYPE=$2
MODEL_NAME=$3

DATA_PATH=/scratch/mt4493/twitter_labor/twitter_labor_data/data/pretraining/${COUNTRY_CODE}
CODE_PATH=/scratch/mt4493/twitter_labor/code/repos_annexe/transformers/examples/distillation/scripts
DUMP_PATH=${DATA_PATH}/distillation/init

SLASH=/
if [[ ${MODEL_NAME} == *"/"* ]]; then
  MODEL_NAME_WITHOUT_SLASH=${MODEL_NAME//[${SLASH}]/_}
else
  MODEL_NAME_WITHOUT_SLASH=${MODEL_NAME}
fi

mkdir -p ${DUMP_PATH}
python3 ${CODE_PATH}/extract_distilbert.py \
--model_type ${MODEL_TYPE} \
--model_name ${MODEL_NAME} \
--dump_checkpoint ${DUMP_PATH}/tf_${MODEL_NAME_WITHOUT_SLASH}.pth