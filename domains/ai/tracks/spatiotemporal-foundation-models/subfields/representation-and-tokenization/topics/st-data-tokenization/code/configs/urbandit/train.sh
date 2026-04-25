#!/usr/bin/env bash
# UrbanDiT 初始复现命令快照。
# 运行前需要先确认数据集名称、机器名和依赖版本。

set -euo pipefail

cd "$(dirname "$0")/../../github/urbandit/src"
mkdir -p experiments

python train_one_step.py \
  --dataset your_training_dataset \
  --batch_ratio 1.0 \
  --norm_type standard \
  --machine your_machine \
  --time_patch 1 \
  --stride 2 \
  --t_patch_len 2 \
  --is_prompt 1 \
  --learning_rate 1e-4 \
  --diffusion_steps 500 \
  --num_inference_steps 20 \
  --pred_len 12 \
  --his_len 12

