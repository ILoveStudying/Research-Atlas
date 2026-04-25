#!/usr/bin/env bash
# 创建 topic 目录，并调用 llm-wiki 初始化独立知识库。
# 用法：
#   bash scripts/create-topic-wiki.sh <domain> <track> <subfield> <topic> "<topic中文名>"

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LLM_WIKI_SKILL_DIR="${LLM_WIKI_SKILL_DIR:-/Users/chizhang/.codex/skills/llm-wiki}"

DOMAIN="${1:?请提供 domain slug}"
TRACK="${2:?请提供 track slug}"
SUBFIELD="${3:?请提供 subfield slug}"
TOPIC="${4:?请提供 topic slug}"
TOPIC_ZH="${5:?请提供 topic 中文名}"

TOPIC_DIR="$ROOT_DIR/domains/$DOMAIN/tracks/$TRACK/subfields/$SUBFIELD/topics/$TOPIC"
WIKI_DIR="$TOPIC_DIR/llm-wiki"

mkdir -p "$TOPIC_DIR"/{papers/{records,notes,pdfs},code/{repos,configs,patches,runs,issues},synthesis}

if [ ! -f "$TOPIC_DIR/README.md" ]; then
  cat > "$TOPIC_DIR/README.md" <<EOF
# $TOPIC_ZH

## 研究问题

请写入这个 topic 的核心研究问题。

## 资产入口

- 论文记录：\`papers/records/\`
- 代码记录：\`code/repos/\`
- 配置快照：\`code/configs/\`
- 复现记录：\`code/runs/\`
- 独立知识库：\`llm-wiki/\`
- 综合产物：\`synthesis/\`
EOF
fi

if [ ! -f "$TOPIC_DIR/topic.yml" ]; then
  cat > "$TOPIC_DIR/topic.yml" <<EOF
slug: $TOPIC
中文名: $TOPIC_ZH
domain: $DOMAIN
track: $TRACK
subfield: $SUBFIELD
状态: 活跃
llm_wiki: llm-wiki
研究目标: []
关键问题: []
EOF
fi

if [ ! -f "$WIKI_DIR/.wiki-schema.md" ]; then
  # llm-wiki 模板替换依赖 perl；显式设置 macOS 常见 UTF-8 locale，减少中文路径警告。
  env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 bash "$LLM_WIKI_SKILL_DIR/scripts/init-wiki.sh" "$WIKI_DIR" "$TOPIC_ZH" "中文"
fi

bash "$ROOT_DIR/scripts/record-update.sh" "新增topic" "$DOMAIN / $TRACK / $SUBFIELD" "$TOPIC" "${TOPIC_DIR#$ROOT_DIR/}" "创建 topic 并初始化独立 llm-wiki"

printf 'topic 已创建：%s\n' "$TOPIC_DIR"
