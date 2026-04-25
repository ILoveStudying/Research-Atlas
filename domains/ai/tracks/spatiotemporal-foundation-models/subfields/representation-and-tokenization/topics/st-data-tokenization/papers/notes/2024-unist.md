# UniST 精读笔记

## 当前状态

已登记论文与代码，官方 GitHub 已作为 submodule 下载到 `code/github/unist`。

## 重点阅读问题

- UniST 的 spatio-temporal knowledge prompt 具体由哪些字段组成？
- `num_memory_spatial` 和 `num_memory_temporal` 如何影响空间/时间记忆池？
- `prompt_content` 的不同组合如何对应空间、周期、上下文提示？
- few-shot / zero-shot 设置是否能作为后续统一 ST-token benchmark 的基线？

## 初始复现入口

- 代码记录：`code/repos/unist.yml`
- 配置快照：`code/configs/unist/`
- 训练入口：`code/configs/unist/train.sh`

