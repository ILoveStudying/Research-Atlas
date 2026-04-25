#!/usr/bin/env bash
# 根据当前 domains 目录生成一个轻量总索引。

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT_DIR/docs/总索引.md"

{
  echo "# 总索引"
  echo
  echo "> 自动生成时间：$(date '+%Y-%m-%d %H:%M:%S %z')"
  echo
  echo "## Topics"
  echo
  find "$ROOT_DIR/domains" -path "*/topics/*/topic.yml" -type f 2>/dev/null | sort | while IFS= read -r topic_file; do
    topic_dir="$(dirname "$topic_file")"
    rel="${topic_dir#$ROOT_DIR/}"
    title="$(grep -E '^中文名:' "$topic_file" | head -n 1 | sed 's/^中文名:[[:space:]]*//')"
    slug="$(grep -E '^slug:' "$topic_file" | head -n 1 | sed 's/^slug:[[:space:]]*//')"
    echo "- [$title](../$rel/)：\`$slug\`"
  done
} > "$OUT"

echo "总索引已生成：$OUT"

