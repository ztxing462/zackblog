---
title: swanlab与pytorch-lightning配置
publishDate: 2025-09-25
description: 'swanlab与pytorch-lightning的配置方案记录'
tags:
  - swanlab
  - pytorch-lightning
  - deep-learning
language: 'Chinese'


toc: 1
slug: swanlab-pytorch-lightning-configuration
---

# swanlab

[SwanLab](https://docs.swanlab.cn/) 是一款开源、轻量的 AI 模型训练跟踪与可视化工具，提供了一个跟踪、记录、比较、和协作实验的平台。

SwanLab 面向人工智能研究者，设计了友好的Python API 和漂亮的UI界面，并提供训练可视化、自动日志记录、超参数记录、实验对比、多人协同等功能。在SwanLab上，研究者能基于直观的可视化图表发现训练问题，对比多个实验找到研究灵感，并通过在线网页的分享与基于组织的多人协同训练，打破团队沟通的壁垒，提高组织训练效率。

借助SwanLab，科研人员可以沉淀自己的每一次训练经验，与合作者无缝地交流和协作，机器学习工程师可以更快地开发可用于生产的模型

1. 📊 实验指标与超参数跟踪: 极简的代码嵌入您的机器学习 pipeline，跟踪记录训练关键指标
2. ⚡️ 全面的框架集成: PyTorch、🤗HuggingFace Transformers、PyTorch Lightning、🦙LLaMA Factory、MMDetection、Ultralytics、PaddleDetetion、LightGBM、XGBoost、Keras、Tensorboard、Weights&Biases、OpenAI、Swift、XTuner、Stable Baseline3、Hydra 在内的 40+ 框架
3. 💻 硬件监控: 支持实时记录与监控CPU、GPU（英伟达Nvidia、沐曦MetaX、摩尔线程MooreThread）、NPU（昇腾Ascend）、MLU（寒武纪MLU）、XPU（昆仑芯KunlunX）、内存的系统级硬件指标
4. 📦 实验管理: 通过专为训练场景设计的集中式仪表板，通过整体视图速览全局，快速管理多个项目与实验
5. 🆚 比较结果: 通过在线表格与对比图表比较不同实验的超参数和结果，挖掘迭代灵感

Tensorboard vs SwanLab
☁️支持在线使用： 通过SwanLab可以方便地将训练实验在云端在线同步与保存，便于远程查看训练进展、管理历史项目、分享实验链接、发送实时消息通知、多端看实验等。而Tensorboard是一个离线的实验跟踪工具。

👥多人协作： 在进行多人、跨团队的机器学习协作时，通过SwanLab可以轻松管理多人的训练项目、分享实验链接、跨空间交流讨论。而Tensorboard主要为个人设计，难以进行多人协作和分享实验。

💻持久、集中的仪表板： 无论你在何处训练模型，无论是在本地计算机上、在实验室集群还是在公有云的GPU实例中，你的结果都会记录到同一个集中式仪表板中。而使用TensorBoard需要花费时间从不同的机器复制和管理 TFEvent文件。

💪更强大的表格： 通过SwanLab表格可以查看、搜索、过滤来自不同实验的结果，可以轻松查看数千个模型版本并找到适合不同任务的最佳性能模型。 TensorBoard 不适用于大型项目。

# pytorch-lightning



# 配置

配置一个swanlab需要在pytorch-lightning的训练器中添加一个回调函数，代码如下：
```python
from swanlab.integrations.pytorch_lightning import SwanLabLogger

swanlab_logger = SwanLabLogger(
    # 这里是设置总的实验名称
    experiment_name="my_experiment",
    # 实验下的每个运行名称
    run_name="run_1",
    # 这里是设置日志保存的目录
    log_dir="./logs",
)

trainer = pl.Trainer(
    # 将swanlab_logger添加到训练器中
    logger=swanlab_logger,
    # 
    callbacks=        [TQDMProgressBar(refresh_rate=10), 
                checkpoint_callback,
                lr_monitor
                ],
    ...
)
```