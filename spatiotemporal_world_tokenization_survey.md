# 大模型时空世界 Token 化顶会论文综述

调研日期：2026-04-25  
参考文章：[两年前我们做了 BIGCity，现在我越来越觉得，大模型缺一块时空感](https://mp.weixin.qq.com/s/CfFFcJ4FeporlYsbqrnEcg)  
方法：按 `academic-researcher` 文献综述框架，围绕研究问题、方法、贡献、局限和未来方向整理。

## 摘要

本文综述“大模型时空世界 token 化”方向的顶会论文。这里的“token 化”不是狭义的文本 tokenizer，而是指将真实世界中的空间位置、时间演化、拓扑结构、动态状态、传感器观测、动作/事件和任务语义，转换为大模型可以统一学习、预测、生成、推理和调用工具的表示接口。微信文章提出的判断非常准确：时空大模型的关键不只是“把经纬度写进 prompt”，而是建立一套新的时空表示层，使模型理解城市、交通、天气、遥感、驾驶和交互世界中的“流动”。

截至 2026-04-25，已确认的顶会论文主要分为四条脉络：视频/交互世界模型、自动驾驶世界模型、城市交通/人流时空基础模型、地球观测/天气基础模型。这些论文尚未形成统一范式，但已经共同指向一个趋势：视觉 token、ST-unit、road segment token、grid patch、sensor node、weather prompt、remote-sensing patch、多时相/多传感器 token，以及 action/event token 正在成为现实世界接入大模型的中间层。

## 1. 纳入标准

本文主表只纳入同时满足以下条件的论文：

1. 发表或明确接收于顶会主会：NeurIPS、ICML、ICLR、CVPR、ICCV、ECCV、KDD、WWW、ICDE 等。
2. 与“大模型/基础模型/世界模型/LLM/VLM/DiT/Transformer 预训练”相关。
3. 明确涉及时空世界的表示统一、tokenizer、prompt、masked pretraining、discrete latent、patch/grid/road/sensor token、时序多模态对齐，或 action/event-conditioned rollout。

未纳入主表但值得跟踪的包括：arXiv 预印本、顶刊论文、产业系统、survey/tutorial，以及只做传统时空预测但不涉及基础模型或 token 化接口的论文。

## 2. 论文总表

| 年份 | 论文 | 会议 | 领域 | Token 化/表示对象 | 主要贡献 |
|---:|---|---|---|---|---|
| 2022 | [SatMAE: Pre-training Transformers for Temporal and Multi-Spectral Satellite Imagery](https://papers.nips.cc/paper_files/paper/2022/hash/01c561df365429f33fcd7a7faa44c985-Abstract-Conference.html) | NeurIPS | 遥感 | 多时相/多光谱 patch、temporal/spectral positional encoding | 将 MAE 扩展到遥感多时相和多光谱数据，是地球观测 token 化的重要早期工作 |
| 2023 | [MAGVIT: Masked Generative Video Transformer](https://openaccess.thecvf.com/content/CVPR2023/html/Yu_MAGVIT_Masked_Generative_Video_Transformer_CVPR_2023_paper.html) | CVPR | 视频世界模型 | 3D video tokenizer、spatial-temporal visual tokens | 用 3D tokenizer 把视频量化为时空视觉 token，并支持多种视频生成任务 |
| 2023 | [ClimaX: A foundation model for weather and climate](https://openreview.net/forum?id=TowCaiz7Ui) | ICML | 天气/气候 | heterogeneous variables、spatiotemporal coverage、physical grounding | 面向异构气候数据和多任务天气/气候建模的 Transformer 基础模型 |
| 2023 | [Scale-MAE](https://openaccess.thecvf.com/content/ICCV2023/html/Reed_Scale-MAE_A_Scale-Aware_Masked_Autoencoder_for_Multiscale_Geospatial_Representation_Learning_ICCV_2023_paper.html) | ICCV | 遥感 | scale-aware patch token、GSD-aware positional encoding | 将地面尺度纳入位置编码，解决遥感多尺度表示问题 |
| 2023 | [SatlasPretrain](https://openaccess.thecvf.com/content/ICCV2023/html/Bastani_SatlasPretrain_A_Large-Scale_Dataset_for_Remote_Sensing_Image_Understanding_ICCV_2023_paper.html) | ICCV | 遥感 | Sentinel/NAIP 图像、任务标签、多尺度空间上下文 | 构建大规模遥感预训练数据与模型，强调时间序列、多传感器和长程空间上下文 |
| 2024 | [Language Model Beats Diffusion: Tokenizer is Key to Visual Generation](https://research.google/pubs/language-model-beats-diffusion-tokenizer-is-key-to-visual-generation/) | ICLR | 视觉/视频生成 | MAGVIT-v2 video/image tokenizer、统一视觉词表 | 证明高质量视觉 tokenizer 可使语言模型式生成超过扩散模型，是“大模型视觉 token 化”的核心论文 |
| 2024 | [Genie: Generative Interactive Environments](https://proceedings.mlr.press/v235/bruce24a.html) | ICML Oral | 交互世界模型 | video state token、latent action token | 从无动作标注视频中学习可交互环境，把状态和动作一起 token 化 |
| 2024 | [Learning Interactive Real-World Simulators](https://proceedings.iclr.cc/paper_files/paper/2024/hash/c4d66eae503694424123b93ac0fbaf17-Abstract-Conference.html) | ICLR | 通用世界模拟器 | image/video/action-conditioned simulation | 提出 UniSim，把多源真实数据组织成可响应动作的世界模拟器 |
| 2024 | [Copilot4D: Learning Unsupervised World Models for Autonomous Driving via Discrete Diffusion](https://proceedings.iclr.cc/paper_files/paper/2024/file/1d41343cf93afd6456db3d1820ce1a58-Paper-Conference.pdf) | ICLR | 自动驾驶 | VQ-VAE sensor tokens、discrete diffusion | 将自动驾驶观测 token 化，再用离散扩散预测未来 |
| 2024 | [UniST: A Prompt-Empowered Universal Model for Urban Spatio-Temporal Prediction](https://openreview.net/forum?id=jO7WWwnZIM) | KDD | 城市时空 | 多场景城市时空序列、ST knowledge prompt | 用预训练和时空知识 prompt 实现跨场景少样本/零样本城市预测 |
| 2024 | [DriveWorld: 4D Pre-Trained Scene Understanding via World Models](https://dblp.org/rec/conf/cvpr/MinZ00XZ0LGXJN024) | CVPR | 自动驾驶 | 4D scene tokens、world model pretraining | 将 4D 场景理解和世界模型预训练结合，用于自动驾驶感知 |
| 2024 | [DriveDreamer](https://eccv.ecva.net/virtual/2024/poster/994) | ECCV | 自动驾驶 | structured traffic constraints、future states | 用真实驾驶场景训练世界模型，兼顾驾驶视频生成和动作预测 |
| 2024 | [SkySense](https://openaccess.thecvf.com/content/CVPR2024/papers/Guo_SkySense_A_Multi-Modal_Remote_Sensing_Foundation_Model_Towards_Universal_Interpretation_CVPR_2024_paper.pdf) | CVPR | 遥感 | multi-modal temporal sequences、SAR/optical token | 多模态遥感基础模型，使用时序 SAR/光学数据和地理上下文 |
| 2024 | [SatMAE++](https://openaccess.thecvf.com/content/CVPR2024/html/Noman_Rethinking_Transformers_Pre-training_for_Multi-Spectral_Satellite_Imagery_CVPR_2024_paper.html) | CVPR | 遥感 | multi-scale/multi-spectral patch token | 重新设计多光谱遥感 Transformer 预训练，增强多尺度重建 |
| 2024 | [GeoChat](https://openaccess.thecvf.com/content/CVPR2024/html/Kuckreja_GeoChat_Grounded_Large_Vision-Language_Model_for_Remote_Sensing_CVPR_2024_paper.html) | CVPR | 遥感 VLM | high-resolution RS image、region inputs、grounding coordinates | 遥感场景的 grounded VLM，把空间区域、坐标和语言问答对齐 |
| 2024 | [Vista: A Generalizable Driving World Model with High Fidelity and Versatile Controllability](https://papers.nips.cc/paper_files/paper/2024/file/a6a066fb44f2fe0d36cf740c873b8890-Paper-Conference.pdf) | NeurIPS | 自动驾驶 | driving video/world state controllable latent | 面向高保真、可控驾驶世界模拟 |
| 2025 | [BIGCity](https://www.bigscity.com/publications/bigcity-a-universal-spatiotemporal-model-for-unified-trajectory-and-traffic-state-data-analysis/) | ICDE | 城市交通 | ST-unit、ST tokenizer、trajectory + traffic state | 用 ST-unit 统一轨迹和交通状态，是微信文章中 ST-token 路线的核心论文 |
| 2025 | [Path-LLM](https://chatpaper.com/chatpaper/paper/129939) | WWW | 交通路径 | road topology token、textual road attributes、path representation | 将道路拓扑和文本语义对齐融合，构建多模态路径表示 |
| 2025 | [WeatherGFM](https://openreview.net/forum?id=izjNI5bcOV) | ICLR | 天气 | weather prompts、多变量/时间序列气象观测 | 用 in-context learning 和 weather prompt 统一多类天气理解任务 |
| 2025 | [EarthDial](https://openaccess.thecvf.com/content/CVPR2025/html/Soni_EarthDial_Turning_Multi-sensory_Earth_Observations_to_Interactive_Dialogues_CVPR_2025_paper.html) | CVPR | 地球观测 VLM | RGB/SAR/multispectral/multi-temporal EO tokens | 将多传感器、多时相地球观测转换为可对话的 VLM 接口 |
| 2025 | [MaskGWM](https://openaccess.thecvf.com/content/CVPR2025/html/Ni_MaskGWM_A_Generalizable_Driving_World_Model_with_Video_Mask_Reconstruction_CVPR_2025_paper.html) | CVPR | 自动驾驶 | spatial-temporal mask tokens、DiT world model | 用视频 mask reconstruction 提升驾驶世界模型泛化 |
| 2025 | [CityGPT](https://vonfeng.github.io/projects/CityGPT/) | KDD | 城市 LLM | CityInstruction、city-scale world model、text spatial benchmark | 将城市尺度世界知识注入 LLM，提升城市空间认知和推理 |
| 2025 | [UrbanMind](https://researchconnect.suny.edu/en/publications/urbanmind-urban-dynamics-prediction-with-multifaceted-spatial-tem/) | KDD | 城市 LLM | multifaceted urban dynamics embeddings、semantic-aware prompt | 用 Mufin-MAE 和语义 prompt 让 LLM 处理多面城市动态预测 |
| 2025 | [Urban Region Pre-training and Prompting](https://chatpaper.com/paper/174717) | KDD | 城市区域 | urban region graph、subgraph-centric pretraining、prompting | 用图预训练和 prompting 学习可迁移城市区域表示 |
| 2025 | [A Universal Model for Human Mobility Prediction](https://cloud.tencent.com/developer/article/2493062) | KDD | 人流/轨迹 | mobility tokens、prompt-based universal model | 统一多城市、多领域人类移动预测，强调生成式预训练和时空 prompt |
| 2025 | [CausalMob](https://www.zhuanzhiai.com/paper/4d7685924dba3cd45d0c6a2a737cbc94) | KDD | 人流/事件 | LLM-derived event intentions、causal mobility representation | 将新闻/公共事件中的人类意图转成因果人流预测信号 |
| 2025 | [Baguan](https://cloud.tencent.com/developer/article/2536972) | KDD | 天气 | weather pretraining representation | 预训练天气预测模型，服务气象时空泛化 |
| 2025 | [UrbanDiT: Diffusion Transformers as Open-World Spatiotemporal Foundation Models](https://openreview.net/forum?id=supy1n4Tev) | NeurIPS | 城市时空 | grid/graph urban data sequentialization、task prompt、DiT | 将扩散 Transformer 扩展到开放世界城市时空基础模型 |

注：KDD 2025 部分论文的 DOI 和正式页面已陆续公开，但部分条目的公开材料仍以作者页、会议列表、arXiv 或论文摘要页为主。综述正文将按证据强弱区分“核心已核验论文”和“方向性补充论文”。

## 3. 研究背景：从“看见世界”到“理解流动”

微信文章的核心观点是：通用大模型虽然可以写作、编程、看图和总结文档，但缺少对真实世界时空变化的内在建模能力。地图上的一条路不是静态线段；它在早高峰、降雨、事故、节假日和城市活动影响下呈现不同状态。遥感图像上的水体也不是静态类别；其边界、涨落和灾害风险来自时间过程。天气、交通、人流、物流和救援路径之间还存在强耦合。

因此，时空世界 token 化要解决的问题是：如何把现实世界中连续、异构、带拓扑、带物理约束的数据流，转换为模型可以统一学习和组合的表示。它位于“真实世界数据接入”和“LLM/VLM/世界模型推理”之间，是一种接口层：

```text
真实世界数据
  -> 表示层 / tokenizer
      ST-unit, road segment, grid patch, sensor node, EO patch, weather prompt, event tuple, action token
  -> 时空模型层
      Transformer, DiT, MAE, VQ-VAE, discrete diffusion, LLM/VLM alignment
  -> 推理和工具层
      prompt, retrieval, GIS, simulator, planner, rule checker
  -> 应用层
      交通预测、轨迹理解、城市规划、灾害响应、天气预报、遥感问答、自动驾驶模拟
```

## 4. 理论框架

### 4.1 Tokenizer 是基础模型能否进入时空世界的瓶颈

MAGVIT 和 MAGVIT-v2 给出了一条非常清晰的路径：先用高质量 tokenizer 将视频压缩成时空 token，再让 Transformer 或语言模型式架构学习 token 序列。MAGVIT 使用 3D tokenizer 将视频量化为空间-时间视觉 token；MAGVIT-v2 进一步强调 tokenizer 是视觉生成成败的关键。它们对城市、遥感、天气和驾驶的启示是：如果表示层不能保留动态、拓扑和任务相关信息，后面的 LLM 或 DiT 很难真正理解世界。

### 4.2 Prompt 是任务接口，Token 是世界接口

UniST、BIGCity、WeatherGFM、UrbanDiT、CityGPT 等论文共同显示：prompt 主要解决“任务如何描述”，token/embedding 主要解决“世界如何进入模型”。例如 UniST 用时空知识 prompt 增强泛化，BIGCity 用 ST task-oriented prompt 调用不同任务，WeatherGFM 用 weather prompt 统一多种气象输入输出，CityGPT 用 CityInstruction 将城市空间知识转成 LLM 可学的指令数据。

### 4.3 世界模型需要状态 token 与动作 token

Genie、UniSim、Copilot4D、DriveDreamer、Vista、MaskGWM 等论文说明，仅有被动观测 token 不足以构成世界模型。真正的世界模型还需要 action/event/intent token：它们表示“如果做某个动作、发生某个事件，世界会如何变化”。Genie 从视频中学习 latent action，Copilot4D 对自动驾驶传感器观测做 VQ-VAE token 化并预测未来，CausalMob 则把新闻事件中的人类意图作为影响人流的因果信号。

### 4.4 时空 token 必须处理多尺度、多模态和拓扑

遥感与城市论文尤其强调多尺度问题。Scale-MAE 使用地面采样距离调整位置编码；SatMAE/SatMAE++ 处理多时相和多光谱 patch；SkySense、EarthDial 同时处理 SAR、光学、多时相和多分辨率数据。城市交通中，road segment、sensor node、grid region、trajectory point 和 POI/event 不在同一空间粒度上，BIGCity 的 ST-unit 和 UrbanDiT 的 grid/graph 序列化正是在尝试统一这些粒度。

## 5. 分主题综述

### 5.1 视频与交互世界模型：从视觉 token 到可交互环境

MAGVIT、MAGVIT-v2 和 Genie 构成视频世界 token 化的三步走。MAGVIT 证明 3D VQ tokenizer 可以把视频压缩成可建模的时空 token；MAGVIT-v2 进一步把图像和视频放进统一视觉词表，让 LLM 式生成具备竞争力；Genie 则从互联网视频中无监督学习可交互环境，把 latent action 也纳入世界表示。这条线的意义在于：时空世界不再只是预测下一帧，而是学习“状态 + 动作 -> 新状态”的生成机制。

UniSim 的贡献在于把真实世界交互数据组织成 universal simulator。它不一定显式使用离散 tokenizer，但在概念上将多源场景、动作和视觉后果对齐到可模拟的生成接口，是世界模型向具身智能和现实交互扩展的重要节点。

### 5.2 自动驾驶世界模型：把道路场景变成可预测的 4D token 流

自动驾驶提供了最接近“时空世界模型”的落地场景。Copilot4D 先用 VQ-VAE token 化传感器观测，再用 discrete diffusion 预测未来；DriveWorld 把 4D 场景理解与世界模型预训练结合；DriveDreamer 和 Vista 强调真实驾驶数据驱动的高保真模拟；MaskGWM 用时空 mask token 和 DiT 做视频重建。

这类论文的问题意识非常集中：驾驶世界不仅有图像，还有道路几何、交通规则、周围车辆、驾驶动作和未来风险。它们的 token 化目标不是压缩视频本身，而是建立可用于预测、规划和安全评估的世界状态表示。

### 5.3 城市交通与人流：ST-token 路线正在成型

城市时空模型是微信文章最关心的主线。UniST 先提出 prompt-empowered universal model，在 20 多个城市时空场景上验证少样本和零样本能力。BIGCity 进一步提出 ST-unit，把个体轨迹和群体交通状态统一起来，支持流量预测、轨迹任务、补全和检索等多任务。UrbanDiT 将扩散 Transformer 扩展到开放世界城市时空学习，试图统一数据类型和任务类型。UrbanMind、CityGPT、Path-LLM 等论文则从 LLM 角度补上语义、指令、路径文本和城市空间认知。

这一方向的关键转变是：过去交通预测往往是“一个模型解决一个城市/一个传感器网络/一个指标”；现在变成“如何让模型获得跨城市、跨任务、跨数据类型的通用时空表示”。ST-token 在这里应至少包含位置、时间、道路拓扑、动态交通状态、区域功能、事件语义和任务要求。

### 5.4 遥感、天气与地球系统：多时相、多传感器、多变量 token

地球观测和天气模型把“时空世界 token 化”推向更复杂的物理系统。SatMAE、Scale-MAE、SatlasPretrain、SatMAE++、SkySense 和 EarthDial 处理遥感数据中的多时相、多光谱、多尺度、多传感器问题；ClimaX 和 WeatherGFM 则处理天气/气候变量的异构性和任务统一。

与城市交通不同，地球系统 token 往往还带有物理变量、分辨率、波段、传感器、地理投影和时间间隔。WeatherGFM 的 weather prompt 提供了一个有趣接口：用 prompt 样例定义气象任务，而不是为每个任务重写模型。EarthDial 则把复杂地球观测转成对话式 VLM 任务，使多时相变化检测、视觉问答和 grounding 可以放在一个交互框架中。

## 6. 代表论文细读

### 6.1 BIGCity

研究问题：轨迹数据和交通状态数据过去被当作两类独立模态处理，导致导航、交通预测和轨迹理解无法共享信息。  
方法：提出 ST-unit 和 ST tokenizer，将轨迹和交通状态统一成可输入大模型的时空单元，并通过 ST task-oriented prompt 支持多任务。  
贡献：这是目前最贴近“ST-token”概念的顶会论文，明确把 heterogeneous ST data representation 作为核心问题。  
局限：仍主要围绕城市道路网络和交通/轨迹任务，距离天气、遥感、人流事件和 GIS 工具链的统一接口还有距离。

### 6.2 UrbanDiT

研究问题：城市时空学习需要同时支持多数据源、多任务和开放世界泛化。  
方法：将城市 grid/graph 类型数据统一序列化，用 diffusion transformer 学习通用时空模式，并通过 prompt 支持不同任务。  
贡献：把 DiT 和 open-world foundation model 语言引入城市时空领域，强调生成、补全、预测的统一。  
局限：扩散模型的物理一致性、实时性和可解释性仍待加强。

### 6.3 MAGVIT-v2

研究问题：为什么 LLM 在视觉生成上长期不如扩散模型。  
方法：设计高质量 video/image tokenizer，用统一词表产生紧凑、表达力强的视觉 token。  
贡献：提出“tokenizer 是关键”的强命题，对所有非文本世界模型都有启发。  
局限：视觉 token 与地理、拓扑、事件、物理约束之间的对齐仍需领域模型补充。

### 6.4 Genie

研究问题：是否可以仅从无动作标注视频中学习可交互世界。  
方法：学习视频 tokenizer、autoregressive dynamics model 和 latent action model。  
贡献：把 action token 纳入世界模型，是从被动视频生成走向交互式世界模拟的关键。  
局限：现实世界中的动作空间、长期一致性和物理约束比游戏/视频场景更复杂。

### 6.5 WeatherGFM

研究问题：气象理解任务输入模态复杂，传统模型难以统一处理。  
方法：设计 weather prompt，将单变量、多变量、时间序列气象输入统一为 in-context learning 任务。  
贡献：展示了 prompt 在物理时空任务中的任务接口作用。  
局限：极端天气、物理守恒和跨区域分布漂移仍是挑战。

## 7. 研究空白

1. 统一 ST-token schema 尚未形成。现有论文各自定义 video token、ST-unit、road segment、grid patch、weather prompt、EO patch，但缺少跨领域的共同字段和互操作协议。
2. 物理约束没有稳定进入 token 生成过程。交通守恒、道路连通性、天气动力学、水文约束和 GIS 规则多数仍作为后处理或外部工具存在。
3. action/event token 仍不成熟。Genie 有 latent action，CausalMob 有事件意图，但城市调度、救援、物流、交通管控中的干预动作如何表示仍是开放问题。
4. 多尺度对齐困难。道路段、网格、遥感 tile、天气网格、行政区、POI 和人流轨迹的空间尺度不同，时间采样也不同。
5. 评测体系不足。需要同时覆盖跨城市、跨模态、跨任务、跨时间分布漂移和开放世界泛化的 benchmark。
6. LLM 与专业时空模型的接口尚未稳定。adapter、projector、retrieval、tool calling、tokenizer、独立 spatiotemporal encoder 接 hidden space 等路线都在竞争。

## 8. 未来方向

1. 设计通用 ST-token schema：包含空间锚点、时间窗口、拓扑邻接、动态属性、语义标签、数据来源、置信度和任务提示。
2. 构建时空 tokenizer benchmark：像视觉领域评估 tokenizer 一样，评估重建、预测、压缩、泛化和下游任务表现。
3. 将 GIS/仿真器/路径规划器变成可调用工具：LLM 不必直接“背下世界”，但需要能可靠调用地图、遥感、天气、交通仿真和规则系统。
4. 发展 event/action-conditioned world model：支持“如果封路/暴雨/地震/演唱会/限行，会发生什么”的反事实推理。
5. 引入物理一致性和可验证生成：结合守恒律、道路拓扑、气象方程、空间统计和不确定性估计。
6. 从单城模型走向全球时空 scaling：UrbanFM、OpenCity、Prithvi-EO、Google Geospatial Reasoning 等虽然不都属于顶会主表，但代表了 scaling 和系统化趋势。

## 9. 重要但未纳入主表的跟踪对象

| 工作 | 状态 | 为什么重要 |
|---|---|---|
| [OpenCity](https://arxiv.org/abs/2408.10269) | arXiv / 开源框架 | 交通预测基础模型，强调开放时空泛化 |
| [UrbanFM](https://arxiv.org/abs/2602.20677) | arXiv 2026 | 提出 WorldST/MiniST unit，代表城市时空 scaling 路线 |
| [Spatio-Temporal Foundation Models: Vision, Challenges, and Opportunities](https://arxiv.org/abs/2501.09045) | Survey | 对 STFMs 的定义、挑战和机会做系统梳理 |
| [Prithvi-EO-2.0](https://arxiv.org/abs/2412.02732) | arXiv / 地球观测基础模型 | 多时相地球观测基础模型，和遥感 token 化高度相关 |
| [Google Geospatial Reasoning](https://blog.google/innovation-and-ai/technology/research/geospatial-reasoning/) | 产业研究系统 | 展示 LLM + 地图/遥感/专有数据/工具链的系统路线 |
| Google Earth AI | 产业系统 | 代表地理空间 AI 基础设施化趋势 |

## 10. 结论

大模型时空世界 token 化已经从“概念”进入“接口成型前夜”。视觉/视频论文证明 tokenizer 决定模型能否高效学习动态世界；城市交通论文开始定义 ST-unit、grid/graph 序列和时空 prompt；自动驾驶论文把世界模型推向可预测、可控、可模拟；遥感和天气论文则证明多时相、多传感器、多变量世界可以通过 patch、prompt 和 VLM 接口进入基础模型。

从 BIGCity 到 UrbanDiT，从 MAGVIT-v2 到 Genie，从 WeatherGFM 到 EarthDial，可以看到同一个方向：模型不只是看见世界，而是开始学习世界如何随空间、时间、动作和事件而变化。下一阶段的关键不在于某个单一模型胜出，而在于表示层、模型层、工具层和应用层能否连接起来，形成可验证、可泛化、可交互的时空世界接口。

## 参考文献与来源

- BIGCity: <https://www.bigscity.com/publications/bigcity-a-universal-spatiotemporal-model-for-unified-trajectory-and-traffic-state-data-analysis/>
- UniST: <https://openreview.net/forum?id=jO7WWwnZIM>
- UrbanDiT: <https://openreview.net/forum?id=supy1n4Tev>
- MAGVIT: <https://openaccess.thecvf.com/content/CVPR2023/html/Yu_MAGVIT_Masked_Generative_Video_Transformer_CVPR_2023_paper.html>
- MAGVIT-v2: <https://research.google/pubs/language-model-beats-diffusion-tokenizer-is-key-to-visual-generation/>
- Genie: <https://proceedings.mlr.press/v235/bruce24a.html>
- UniSim: <https://proceedings.iclr.cc/paper_files/paper/2024/hash/c4d66eae503694424123b93ac0fbaf17-Abstract-Conference.html>
- Copilot4D: <https://proceedings.iclr.cc/paper_files/paper/2024/file/1d41343cf93afd6456db3d1820ce1a58-Paper-Conference.pdf>
- DriveDreamer: <https://eccv.ecva.net/virtual/2024/poster/994>
- DriveWorld: <https://dblp.org/rec/conf/cvpr/MinZ00XZ0LGXJN024>
- Vista: <https://papers.nips.cc/paper_files/paper/2024/file/a6a066fb44f2fe0d36cf740c873b8890-Paper-Conference.pdf>
- ClimaX: <https://openreview.net/forum?id=TowCaiz7Ui>
- WeatherGFM: <https://openreview.net/forum?id=izjNI5bcOV>
- SatMAE: <https://papers.nips.cc/paper_files/paper/2022/hash/01c561df365429f33fcd7a7faa44c985-Abstract-Conference.html>
- Scale-MAE: <https://openaccess.thecvf.com/content/ICCV2023/html/Reed_Scale-MAE_A_Scale-Aware_Masked_Autoencoder_for_Multiscale_Geospatial_Representation_Learning_ICCV_2023_paper.html>
- SatlasPretrain: <https://openaccess.thecvf.com/content/ICCV2023/html/Bastani_SatlasPretrain_A_Large-Scale_Dataset_for_Remote_Sensing_Image_Understanding_ICCV_2023_paper.html>
- SkySense: <https://openaccess.thecvf.com/content/CVPR2024/papers/Guo_SkySense_A_Multi-Modal_Remote_Sensing_Foundation_Model_Towards_Universal_Interpretation_CVPR_2024_paper.pdf>
- SatMAE++: <https://openaccess.thecvf.com/content/CVPR2024/html/Noman_Rethinking_Transformers_Pre-training_for_Multi-Spectral_Satellite_Imagery_CVPR_2024_paper.html>
- GeoChat: <https://openaccess.thecvf.com/content/CVPR2024/html/Kuckreja_GeoChat_Grounded_Large_Vision-Language_Model_for_Remote_Sensing_CVPR_2024_paper.html>
- EarthDial: <https://openaccess.thecvf.com/content/CVPR2025/html/Soni_EarthDial_Turning_Multi-sensory_Earth_Observations_to_Interactive_Dialogues_CVPR_2025_paper.html>
- MaskGWM: <https://openaccess.thecvf.com/content/CVPR2025/html/Ni_MaskGWM_A_Generalizable_Driving_World_Model_with_Video_Mask_Reconstruction_CVPR_2025_paper.html>
- CityGPT: <https://vonfeng.github.io/projects/CityGPT/>
- UrbanMind: <https://researchconnect.suny.edu/en/publications/urbanmind-urban-dynamics-prediction-with-multifaceted-spatial-tem/>
- Path-LLM: <https://chatpaper.com/chatpaper/paper/129939>
- Urban Region Pre-training and Prompting: <https://chatpaper.com/paper/174717>
- CausalMob: <https://www.zhuanzhiai.com/paper/4d7685924dba3cd45d0c6a2a737cbc94>
- Baguan: <https://cloud.tencent.com/developer/article/2536972>
