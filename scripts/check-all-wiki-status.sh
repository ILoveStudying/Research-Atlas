#!/usr/bin/env bash
# 检查仓库内所有 topic 的 llm-wiki 初始化状态。

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "llm-wiki 状态检查"
echo

FOUND=0
while IFS= read -r schema; do
  FOUND=1
  wiki_dir="$(dirname "$schema")"
  rel="${wiki_dir#$ROOT_DIR/}"
  if [ -f "$wiki_dir/purpose.md" ] && [ -d "$wiki_dir/raw" ] && [ -d "$wiki_dir/wiki" ]; then
    echo "[正常] $rel"
  else
    echo "[不完整] $rel"
  fi
done < <(find "$ROOT_DIR/domains" -path "*/llm-wiki/.wiki-schema.md" -type f 2>/dev/null | sort)

if [ "$FOUND" -eq 0 ]; then
  echo "未发现已初始化的 llm-wiki。"
fi

