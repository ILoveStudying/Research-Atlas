# research-atlas

`research-atlas` 是一个面向终身使用的学术研究调研仓库。它把研究对象组织成可路由、可复现、可持续更新的层级结构，并在每个最终 topic 下维护一个独立的 `llm-wiki` 知识库。

## 仓库定位

本仓库不是单次综述文件夹，而是长期积累研究资产的工作台：

- 用 `domain -> track -> subfield -> topic` 路由到任意研究细节。
- 每个 topic 独立保存论文、代码、配置、实验记录和 `llm-wiki`。
- 顶层 `registry/` 维护全局目录、论文索引、代码索引和更新日志。
- 每次通过脚本新增 topic、论文或代码记录时，都会自动追加 `研究更新日志.md`。

## 核心层级

```text
domain    研究大领域，例如 AI、系统、机器人、科学智能
track     领域内研究方向，例如时空大模型、多模态大模型、世界模型
subfield  方向下的问题簇，例如表示学习与 Token 化
topic     最终落地单元，例如时空数据 Token 化
```

## 关键目录

```text
docs/       中文说明文档
registry/   全局路由表、论文表、代码表、更新记录
templates/  新增领域、topic、论文、代码时复用的模板
scripts/    中文注释的维护脚本
domains/    按 domain/track/subfield/topic 存放研究资产
```

## 内容添加入口

请优先使用脚本新增内容，这样可以保证全局记录同步更新：

```bash
# 新建一个 topic，并初始化独立 llm-wiki
bash scripts/create-topic-wiki.sh ai spatiotemporal-foundation-models representation-and-tokenization st-data-tokenization "时空数据 Token 化"

# 添加论文记录
bash scripts/add-paper-record.sh domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization 2025-bigcity "BIGCity" 2025 ICDE A1 "论文链接" "代码链接"

# 添加代码记录
bash scripts/add-code-record.sh domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization bigcity "BIGCity" papers/records/2025-bigcity.yml "代码链接" PyTorch
```

## 当前种子 topic

```text
AI
└── 时空大模型
    └── 表示学习与 Token 化
        └── 时空数据 Token 化
```

该 topic 已预留论文、代码、配置、复现记录、综合文档和独立 `llm-wiki` 目录。

## 推荐工作流

1. 在 `registry/taxonomy.yml` 中确认研究路由。
2. 使用 `scripts/create-topic-wiki.sh` 新建 topic。
3. 把论文登记到 `papers/records/`，把代码登记到 `code/repos/`。
4. 将论文 PDF、网页、代码说明或笔记交给对应 topic 的 `llm-wiki` 消化。
5. 用 `scripts/generate-index.sh` 刷新总索引。
6. 定期运行 `scripts/check-all-wiki-status.sh` 检查所有 topic 的 wiki 状态。

