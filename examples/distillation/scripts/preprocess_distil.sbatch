#!/bin/bash

#SBATCH --job-name=preprocessing_distil
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB
#SBATCH --time=24:00:00
#SBATCH --gres=gpu:0
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=mt4493@nyu.edu
#SBATCH --output=slurm_preprocessing_distil-%j.out

COUNTRY_CODE=$1
DATA_FOLDER=$2
MODEL_TYPE=$3
MODEL_NAME=$4
VOCAB_SIZE=$5

SLASH=/
if [[ ${MODEL_NAME} == *"/"* ]]; then
  MODEL_NAME_WITHOUT_SLASH=${MODEL_NAME//[${SLASH}]/_}
else
  MODEL_NAME_WITHOUT_SLASH=${MODEL_NAME}
fi

DATA_PATH=/scratch/mt4493/twitter_labor/twitter-labor-data/data/pretraining/${COUNTRY_CODE}
CODE_PATH=/scratch/mt4493/twitter_labor/code/repos_annexe/transformers/examples/distillation/scripts
DUMP_PATH=${DATA_PATH}/distillation

module purge
module load anaconda3/2019.10
source /scratch/mt4493/twitter_labor/code/envs/experimental_env/bin/activate
echo "virtualenv activated"


# if not exist, build init checkpoint
mkdir -p ${DUMP_PATH}/init
if [ ! -f ${DUMP_PATH}/init/tf_${MODEL_NAME_WITHOUT_SLASH}.pth ]; then
  echo "Starting to build init checkpoint"
  python3 ${CODE_PATH}/extract_distilbert.py \
  --model_type ${MODEL_TYPE} \
  --model_name ${MODEL_NAME} \
  --dump_checkpoint ${DUMP_PATH}/init/tf_${MODEL_NAME_WITHOUT_SLASH}.pth
  echo "Done building init checkpoint"
fi

if [ ! -f ${DUMP_PATH}/dump_${DATA_FOLDER}_${MODEL_NAME_WITHOUT_SLASH}.pickle ]; then
  echo "Starting to binarize data"
  python3 ${CODE_PATH}/binarized_data.py \
  --file_path ${DATA_PATH}/tweets_${DATA_FOLDER}.txt \
  --tokenizer_type ${MODEL_TYPE}\
  --tokenizer_name ${MODEL_NAME}\
  --dump_file ${DUMP_PATH}/dump_${DATA_FOLDER}_${MODEL_NAME_WITHOUT_SLASH}
  echo "Done binarizing data"
fi
#
#if [ ! -f ${DUMP_PATH}/token_counts_${DATA_FOLDER}_${MODEL_NAME_WITHOUT_SLASH}.pickle ]; then
#  echo "Counting tokens"
#  python3 ${CODE_PATH}/token_counts.py \
#  --data_file ${DUMP_PATH}/dump_${DATA_FOLDER}_${MODEL_NAME_WITHOUT_SLASH}.pickle \
#  --token_counts_dump ${DUMP_PATH}/token_counts_${DATA_FOLDER}_${MODEL_NAME_WITHOUT_SLASH}.pickle \
#  --vocab_size ${VOCAB_SIZE}
#  echo "Done counting tokens"
#fi



