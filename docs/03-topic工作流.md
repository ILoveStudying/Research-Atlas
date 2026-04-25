# topic 工作流

## topic 内部结构

```text
topic/
├── README.md
├── topic.yml
├── llm-wiki/
├── papers/
├── code/
└── synthesis/
```

## 论文层

- `papers/records/`：结构化论文记录。
- `papers/notes/`：精读笔记、人读总结。
- `papers/pdfs/`：论文 PDF，可使用 Git LFS 或只登记链接。

## 代码层

- `code/repos/`：官方代码、复现代码、fork 的登记。
- `code/configs/`：关键配置快照、训练命令、环境文件。
- `code/patches/`：对官方代码做过的补丁。
- `code/runs/`：复现实验记录。
- `code/issues/`：环境坑、依赖冲突、数据问题。

## wiki 层

每个 topic 有独立 `llm-wiki`。消化论文和代码时，优先让 wiki 形成以下页面：

- `wiki/sources/`：素材摘要页。
- `wiki/entities/`：方法、模型、数据集、指标、概念。
- `wiki/topics/`：topic 内的子问题。
- `wiki/synthesis/`：跨素材综合报告。

