#!/usr/bin/env bash
# 追加一条全局内容更新记录。
# 用法：
#   bash scripts/record-update.sh <类型> <范围> <标题> <路径> [说明]

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TYPE="${1:?请提供类型，例如 新增topic / 新增论文 / 新增代码}"
SCOPE="${2:?请提供范围，例如 AI / 时空大模型}"
TITLE="${3:?请提供标题}"
TARGET_PATH="${4:?请提供路径}"
DETAIL="${5:-}"
TIME="$(date '+%Y-%m-%d %H:%M:%S %z')"

MARKDOWN_LOG="$ROOT_DIR/研究更新日志.md"
YAML_LOG="$ROOT_DIR/registry/update-log.yml"

mkdir -p "$ROOT_DIR/registry"

if [ ! -f "$MARKDOWN_LOG" ]; then
  printf '# 研究更新日志\n\n' > "$MARKDOWN_LOG"
fi

if [ ! -f "$YAML_LOG" ]; then
  : > "$YAML_LOG"
fi

{
  printf '\n## %s | %s | %s\n\n' "$TIME" "$TYPE" "$TITLE"
  printf -- '- 范围：%s\n' "$SCOPE"
  printf -- '- 路径：%s\n' "$TARGET_PATH"
  if [ -n "$DETAIL" ]; then
    printf -- '- 说明：%s\n' "$DETAIL"
  fi
} >> "$MARKDOWN_LOG"

{
  printf -- '- 时间: "%s"\n' "$TIME"
  printf '  类型: "%s"\n' "$TYPE"
  printf '  范围: "%s"\n' "$SCOPE"
  printf '  标题: "%s"\n' "$TITLE"
  printf '  路径: "%s"\n' "$TARGET_PATH"
  printf '  说明: "%s"\n' "$DETAIL"
} >> "$YAML_LOG"

printf '已记录更新：%s | %s\n' "$TYPE" "$TITLE"

