#!/usr/bin/env bash
# 在指定 topic 下新增论文记录，并同步追加全局更新日志。
# 用法：
#   bash scripts/add-paper-record.sh <topic路径> <论文id> "<标题>" <年份> <会议> <分级> "<论文链接>" "<代码链接>"

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOPIC_DIR="${1:?请提供 topic 路径}"
PAPER_ID="${2:?请提供论文 id}"
TITLE="${3:?请提供论文标题}"
YEAR="${4:?请提供年份}"
VENUE="${5:?请提供会议}"
TIER="${6:?请提供分级}"
PAPER_URL="${7:-}"
CODE_URL="${8:-}"

ABS_TOPIC_DIR="$ROOT_DIR/$TOPIC_DIR"
RECORD_DIR="$ABS_TOPIC_DIR/papers/records"
NOTES_DIR="$ABS_TOPIC_DIR/papers/notes"
RECORD_PATH="$RECORD_DIR/$PAPER_ID.yml"
NOTE_PATH="$NOTES_DIR/$PAPER_ID.md"

mkdir -p "$RECORD_DIR" "$NOTES_DIR"

if [ -f "$RECORD_PATH" ]; then
  echo "论文记录已存在：$RECORD_PATH"
  exit 1
fi

cat > "$RECORD_PATH" <<EOF
id: $PAPER_ID
标题: "$TITLE"
年份: $YEAR
会议: "$VENUE"
分级: "$TIER"
论文链接: "$PAPER_URL"
代码链接: "$CODE_URL"
数据集链接: ""
状态: 已登记
是否已消化到wiki: false
是否已复现: false
核心贡献: []
局限: []
关联代码记录: ""
EOF

cat > "$NOTE_PATH" <<EOF
# $TITLE

## 当前状态

已登记论文信息，等待精读和消化到 llm-wiki。

## 待读问题

- 这篇论文解决什么问题？
- 方法核心假设是什么？
- 关键配置和实现细节在哪里？
- 与同 topic 其他论文有什么差异？
EOF

cat >> "$ROOT_DIR/registry/paper-catalog.yml" <<EOF
- id: $PAPER_ID
  标题: "$TITLE"
  年份: $YEAR
  会议: "$VENUE"
  分级: "$TIER"
  topic路径: "$TOPIC_DIR"
  记录路径: "$TOPIC_DIR/papers/records/$PAPER_ID.yml"
  状态: 已登记
EOF

bash "$ROOT_DIR/scripts/record-update.sh" "新增论文" "$TOPIC_DIR" "$PAPER_ID" "$TOPIC_DIR/papers/records/$PAPER_ID.yml" "$TITLE"

printf '论文记录已创建：%s\n' "$RECORD_PATH"

