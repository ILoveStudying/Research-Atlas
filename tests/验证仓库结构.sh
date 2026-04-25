#!/usr/bin/env bash
# 验证 research-atlas 仓库骨架是否包含长期维护所需的关键文件。

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOPIC_DIR="$ROOT_DIR/domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization"

require_file() {
  local path="$1"
  if [ ! -f "$ROOT_DIR/$path" ]; then
    echo "缺少文件：$path"
    exit 1
  fi
}

require_executable() {
  local path="$1"
  require_file "$path"
  if [ ! -x "$ROOT_DIR/$path" ]; then
    echo "脚本不可执行：$path"
    exit 1
  fi
}

require_contains() {
  local path="$1"
  local text="$2"
  require_file "$path"
  if ! grep -Fq "$text" "$ROOT_DIR/$path"; then
    echo "文件 $path 未包含期望内容：$text"
    exit 1
  fi
}

require_file "README.md"
require_file ".gitignore"
require_file "研究更新日志.md"

require_file "docs/00-使用手册.md"
require_file "docs/01-研究分类体系.md"
require_file "docs/02-顶会与论文分级.md"
require_file "docs/03-topic工作流.md"
require_file "docs/04-命名规范.md"
require_file "docs/05-持续更新规范.md"
require_file "docs/06-仓库设计方案.md"

require_file "registry/taxonomy.yml"
require_file "registry/venues.yml"
require_file "registry/wiki-catalog.yml"
require_file "registry/paper-catalog.yml"
require_file "registry/code-catalog.yml"
require_file "registry/update-log.yml"

require_file "templates/topic-README-template.md"
require_file "templates/topic-meta-template.yml"
require_file "templates/paper-record-template.yml"
require_file "templates/code-record-template.yml"
require_file "templates/run-record-template.md"

require_executable "scripts/record-update.sh"
require_executable "scripts/create-topic-wiki.sh"
require_executable "scripts/add-paper-record.sh"
require_executable "scripts/add-code-record.sh"
require_executable "scripts/check-all-wiki-status.sh"
require_executable "scripts/generate-index.sh"

require_file "domains/ai/README.md"
require_file "domains/ai/domain.yml"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/README.md"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/track.yml"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/README.md"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/subfield.yml"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/README.md"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/topic.yml"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/llm-wiki/.wiki-schema.md"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/llm-wiki/purpose.md"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/papers/records/2025-bigcity.yml"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/code/repos/bigcity.yml"
require_file "domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/synthesis/大模型时空世界Token化顶会论文综述.md"

require_contains "README.md" "research-atlas"
require_contains "研究更新日志.md" "st-data-tokenization"
require_contains "registry/update-log.yml" "st-data-tokenization"
require_contains "registry/wiki-catalog.yml" "llm-wiki"
require_contains "scripts/record-update.sh" "追加一条全局内容更新记录"

if [ ! -d "$TOPIC_DIR/llm-wiki/raw" ] || [ ! -d "$TOPIC_DIR/llm-wiki/wiki" ]; then
  echo "topic 的 llm-wiki 目录不完整：$TOPIC_DIR/llm-wiki"
  exit 1
fi

echo "仓库结构验证通过"
