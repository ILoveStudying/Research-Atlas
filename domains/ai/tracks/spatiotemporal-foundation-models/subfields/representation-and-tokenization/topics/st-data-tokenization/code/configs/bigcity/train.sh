#!/usr/bin/env bash
# BIGCity 训练命令快照。
# 当前文件用于记录复现入口；拿到官方代码后再补齐真实命令。

set -euo pipefail

cd "$(dirname "$0")/../../github/bigcity"

echo "Stage 1: masked reconstruction pretraining"
python pretrain.py \
  --task_name pretrain \
  --use_gpu \
  --root_path ../dataset/ \
  --city xa \
  --mask_rate 0.5 \
  --batch_size 32 \
  --learning_rate 2e-4 \
  --train_epochs 20

echo "Stage 2: task-oriented prompt tuning"
python finetune.py \
  --use_gpu \
  --root_path ../dataset/ \
  --city xa \
  --batch_size 32 \
  --learning_rate 2e-4 \
  --train_epochs 20
