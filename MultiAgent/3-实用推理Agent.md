# 实用推理Agent
---

## 实用推理

### 定义
+ 直接通过推理得到动作，权衡各种观点的不同，这些不同的观点来自于Agent的愿望/评价/关心的问题以及Agent相信的事情
+ 与理论推理的不同
  + 理论推理直接导致信念
  + 实用推理导致动作

### 组成
+ 人类的实用推理由两个部分组成
  + **慎思过程**：决定要实现的信念，得到意图
  + **目标手段推理**：决定如何实现这些信念，得到规划

## 意图
+ 意图可以刻画动作和思维状态
+ 意图在实用推理中起的作用
  + 意图驱动目标手段推理
    + Agent一旦形成了某个意图，就会投入资源来决定如何实现这一意图
  + 意图约束未来慎思
  + 意图的持续性
    + 一般不会轻易放弃某个意图
  + 意图与信念密切相关
  + Agent不一定想要接受意图的所有预期副作用
    + 如果Agent相信$\phi\rightarrow \psi$并且想要实现$\phi$，并不意味着Agent想要实现$\psi$

---
## 目标手段推理/规划
+ 规划是行动方案的设计
  + 规划器是接受下列输入表示的系统
    + 目标、意图或任务
    + 当前的环境状态
    + Agent可以采取的动作