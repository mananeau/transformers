#!/bin/bash

#SBATCH --job-name=train_distil
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40GB
#SBATCH --time=24:00:00
#SBATCH --gres=gpu:4
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=mt4493@nyu.edu
#SBATCH --output=slurm_train_distil-%j.out

COUNTRY_CODE=$1
MODEL_TYPE=$2
MODEL_NAME=$3
DATA_FOLDER=$4

DATA_PATH=/scratch/mt4493/twitter_labor/twitter_labor_data/data/pretraining/${COUNTRY_CODE}
DUMP_PATH=${DATA_PATH}/distillation
CODE_PATH=/scratch/mt4493/twitter_labor/code/repos_annexe/transformers/examples/distillation/scripts


if [[ ${MODEL_NAME} == *"/"* ]]; then
  MODEL_NAME_WITHOUT_SLASH=${MODEL_NAME//[${SLASH}]/_}
else
  MODEL_NAME_WITHOUT_SLASH=${MODEL_NAME}
fi

mkdir -p ${DUMP_PATH}/checkpoints/${MODEL_NAME_WITHOUT_SLASH}_${DATA_FOLDER}

export NODE_RANK=0
export N_NODES=1

export N_GPU_NODE=4
export WORLD_SIZE=4
export MASTER_PORT=<AN_OPEN_PORT>
export MASTER_ADDR=<I.P.>

cd ${CODE_PATH}

pkill -f 'python -u train.py'

python -m torch.distributed.launch \
    --nproc_per_node=$N_GPU_NODE \
    --nnodes=$N_NODES \
    --node_rank $NODE_RANK \
    --master_addr $MASTER_ADDR \
    --master_port $MASTER_PORT \
    train.py \
        --force \
        --gpus $WORLD_SIZE \
        --student_type distilbert \
        --student_config training_configs/distilbert-base-uncased.json \
        --student_pretrained_weights ${DUMP_PATH}/init/tf_${MODEL_NAME_WITHOUT_SLASH}.pth \
        --teacher_type ${MODEL_TYPE} \
        --teacher_name ${MODEL_NAME} \
        --alpha_ce 0.33 --alpha_mlm 0.33 --alpha_cos 0.33 --alpha_clm 0.0 --mlm \
        --freeze_pos_embs \
        --dump_path ${DUMP_PATH}/checkpoints/${MODEL_NAME_WITHOUT_SLASH}_${DATA_FOLDER} \
        --data_file ${DUMP_PATH}/dump_${DATA_FOLDER}_${MODEL_NAME_WITHOUT_SLASH}.pickle \
        --token_counts ${DUMP_PATH}/token_counts_${DATA_FOLDER}_${MODEL_NAME_WITHOUT_SLASH}.pickle
