#!/usr/bin/env bash
# 在指定 topic 下新增代码仓库记录，并同步追加全局更新日志。
# 用法：
#   bash scripts/add-code-record.sh <topic路径> <代码id> "<项目名>" <论文记录路径> "<仓库链接>" <主要框架>

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOPIC_DIR="${1:?请提供 topic 路径}"
CODE_ID="${2:?请提供代码 id}"
PROJECT_NAME="${3:?请提供项目名}"
PAPER_RECORD="${4:?请提供来源论文记录路径}"
REPO_URL="${5:-}"
FRAMEWORK="${6:-未知}"

ABS_TOPIC_DIR="$ROOT_DIR/$TOPIC_DIR"
REPO_DIR="$ABS_TOPIC_DIR/code/repos"
CONFIG_DIR="$ABS_TOPIC_DIR/code/configs/$CODE_ID"
RECORD_PATH="$REPO_DIR/$CODE_ID.yml"

mkdir -p "$REPO_DIR" "$CONFIG_DIR"

if [ -f "$RECORD_PATH" ]; then
  echo "代码记录已存在：$RECORD_PATH"
  exit 1
fi

cat > "$RECORD_PATH" <<EOF
id: $CODE_ID
项目名: "$PROJECT_NAME"
来源论文: "$PAPER_RECORD"
官方仓库: "$REPO_URL"
主要框架: "$FRAMEWORK"
复现状态: 待复现
配置位置:
  - code/configs/$CODE_ID/
已知问题: []
复现记录: []
EOF

cat > "$CONFIG_DIR/README.md" <<EOF
# $PROJECT_NAME 配置快照

请在这里记录环境、训练、数据、tokenizer 和推理配置。
EOF

cat >> "$ROOT_DIR/registry/code-catalog.yml" <<EOF
- id: $CODE_ID
  项目名: "$PROJECT_NAME"
  来源论文: "$PAPER_RECORD"
  topic路径: "$TOPIC_DIR"
  记录路径: "$TOPIC_DIR/code/repos/$CODE_ID.yml"
  复现状态: 待复现
EOF

bash "$ROOT_DIR/scripts/record-update.sh" "新增代码" "$TOPIC_DIR" "$CODE_ID" "$TOPIC_DIR/code/repos/$CODE_ID.yml" "$PROJECT_NAME"

printf '代码记录已创建：%s\n' "$RECORD_PATH"

