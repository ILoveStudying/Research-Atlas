#!/usr/bin/env bash
# UniST 初始复现命令快照。
# 运行前需要先根据 dataset/README.md 准备数据。

set -euo pipefail

cd "$(dirname "$0")/../../github/unist/src"
mkdir -p experiments

echo "Stage 1: large-scale spatio-temporal pre-training"
python main.py \
  --device_id 0 \
  --machine machine \
  --dataset Crowd \
  --task short \
  --size middle \
  --mask_strategy_random batch \
  --lr 3e-4 \
  --used_data single \
  --prompt_ST 0

echo "Stage 2: spatio-temporal knowledge-guided prompt tuning"
python main.py \
  --device_id 0 \
  --machine machine \
  --task short \
  --size middle \
  --prompt_ST 1 \
  --pred_len 6 \
  --his_len 6 \
  --num_memory_spatial 512 \
  --num_memory_temporal 512 \
  --prompt_content s_p_c \
  --dataset Crowd \
  --lr 3e-4 \
  --used_data single \
  --file_load_path pretrained_model_path

