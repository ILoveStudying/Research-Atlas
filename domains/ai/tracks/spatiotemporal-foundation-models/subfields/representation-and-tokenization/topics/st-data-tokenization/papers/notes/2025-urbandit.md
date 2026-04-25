# UrbanDiT 精读笔记

## 当前状态

已登记论文与代码，官方 GitHub 已作为 submodule 下载到 `code/github/urbandit`。

## 重点阅读问题

- UrbanDiT 如何统一不同城市时空数据类型？
- `time_patch`、`stride`、`t_patch_len` 与时空 token 粒度之间是什么关系？
- mask strategy 如何映射到双向预测、时间插值、空间外推和时空补全？
- prompt learning 在 denoising pipeline 中承担任务路由还是数据语义对齐？

## 初始复现入口

- 代码记录：`code/repos/urbandit.yml`
- 配置快照：`code/configs/urbandit/`
- 训练入口：`code/configs/urbandit/train.sh`

