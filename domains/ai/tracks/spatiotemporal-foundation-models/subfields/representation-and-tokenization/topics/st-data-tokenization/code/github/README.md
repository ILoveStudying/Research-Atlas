# GitHub 下载区

这里保存通过 Git submodule 下载的外部代码仓库。这样本地可以直接阅读和运行代码，主仓库也不会把第三方代码完整复制进历史。

## 当前 submodule

| 项目 | 仓库 | 本地目录 | 固定 commit |
|---|---|---|---|
| UniST | https://github.com/tsinghua-fib-lab/UniST.git | `unist` | `6ee69db00d8f67e550f9bc3c06f004f9f7885703` |
| BIGCity | https://github.com/bigscity/BIGCity.git | `bigcity` | `5f7168bf7a43c3a40e19e4a80cdb6d77b080edec` |
| UrbanDiT | https://github.com/tsinghua-fib-lab/UrbanDiT.git | `urbandit` | `c286b23bf63c7f5a1a5b8c150c20bafb2c7a0ce4` |

## 克隆后的恢复方式

```bash
git submodule update --init --recursive
```

## 更新方式

更新外部代码前先记录原因，再执行：

```bash
git submodule update --remote domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/code/github/unist
git submodule update --remote domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/code/github/bigcity
git submodule update --remote domains/ai/tracks/spatiotemporal-foundation-models/subfields/representation-and-tokenization/topics/st-data-tokenization/code/github/urbandit
```

