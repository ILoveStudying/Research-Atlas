# Research Atlas Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 创建一个中文文档化、可持续更新的学术研究调研仓库骨架。

**Architecture:** 顶层仓库维护全局 registry、模板、脚本和说明文档；最终研究资产落到 topic；每个 topic 内部维护独立 `llm-wiki`、论文、代码、配置、实验记录和综合产物。

**Tech Stack:** Markdown、YAML、Bash、llm-wiki 初始化脚本。

---

### Task 1: 结构验证

**Files:**
- Create: `tests/验证仓库结构.sh`

- [x] **Step 1: 写入失败测试**

创建结构验证脚本，检查 README、registry、scripts、topic、llm-wiki 和种子论文代码记录。

- [x] **Step 2: 验证测试失败**

Run: `tests/验证仓库结构.sh`

Expected: 失败并提示缺少 `README.md`。

### Task 2: 仓库骨架

**Files:**
- Create: `README.md`
- Create: `docs/*.md`
- Create: `registry/*.yml`
- Create: `templates/*`
- Create: `domains/ai/**`

- [x] **Step 1: 创建中文文档和元数据**

写入仓库说明、分类体系、顶会分级、topic 工作流、命名规范和持续更新规范。

- [x] **Step 2: 创建种子 topic**

创建 `st-data-tokenization` topic，并放入论文、代码、配置和综合目录。

### Task 3: 自动记录脚本

**Files:**
- Create: `scripts/record-update.sh`
- Create: `scripts/create-topic-wiki.sh`
- Create: `scripts/add-paper-record.sh`
- Create: `scripts/add-code-record.sh`
- Create: `scripts/check-all-wiki-status.sh`
- Create: `scripts/generate-index.sh`

- [x] **Step 1: 实现统一记录入口**

`record-update.sh` 追加 `研究更新日志.md` 和 `registry/update-log.yml`。

- [x] **Step 2: 让新增 topic、论文、代码脚本调用记录入口**

新增内容后自动记录路径、范围和说明。

### Task 4: llm-wiki 初始化与验证

**Files:**
- Create: `domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/llm-wiki/*`

- [x] **Step 1: 调用 llm-wiki 初始化脚本**

Run: `bash /Users/chizhang/.codex/skills/llm-wiki/scripts/init-wiki.sh <topic>/llm-wiki "时空数据 Token 化" "中文"`

- [x] **Step 2: 运行结构验证**

Run: `tests/验证仓库结构.sh`

Expected: 输出 `仓库结构验证通过`。

