# Cross-Modal Domain Adaptation for Cost-Efficient Visual Reinforcement Learning

# Motivation
+ 在sim2real的工作中，需要为simulator和真实世界的状态寻找某种同质的状态表示
+ 现有的工作主要是在模拟器和真实世界之间，在同模态的状态表示上寻找某种关联（比如模拟器render的图像和真实世界的图像），但是则需要使用image-based simulator，往往更慢
+ 更好的解决方案是使用state-based simulator训练策略，然后通过domain adaptation将学习到的策略适应到真实世界的图像上

# Method
+ 假设在源域（state-based）有$s_t\in \mathcal{S}$对应状态，$p(s|s_{t-1}, a_{t-1})$对应源域上的转移模型
+ 在目标域上，有观察$o_t\in \mathcal{O} $仅依赖于当前状态$s_t$和上一时刻观察$o_{t-1}$（可以被看作观察模型，事实上也是我们需要寻找的映射）
+ 我们希望寻找$q_\phi (s_t|s_{t-1}, a_{t-1}, o_t)$，使得通过上一时刻状态、当前时刻观察和上一时刻行动能够推断出当前时刻的状态，从而能够利用模拟器进行训练。具体而言，优化目标为轨迹优化
  $$\min _{\phi} \mathbb{E}_{\tau^{o}}\left[D_{\mathrm{KL}}\left[q_{\phi}\left(\tau^{s} \mid \tau^{o}\right) \| p\left(\tau^{s} \mid \tau^{o}\right)\right]\right]$$

# 实验
## 对照组
+ BC: 直接根据图像($o$)克隆智能体选择的动作$a$
+ GAN: 使用直接使用GAN学习映射函数$p_\phi(s|o)$
+ CycleGAN: 没看懂，类似GAN
+ GAN with Stacked Input: 将多帧的历史序列组合后作为输入

## 注意点
+ codas不需要paired data，只是分别需要source domain和target domain上两份trajectory数据。其中source domain上的轨迹数据仅仅用于训练GAN

## 实验结果
+ BC在HalfCheetah上性能量良好，在其他环境中较差，可能是由于其他人任务中BC没有足够的数据来学到一个好的策略
+ GAN/CycleGAN在Swimmer和HalfCheetah这两个比较稳定的环境中性能较好 ，因为环境比较稳定，智能体即使在出现state mismatch也能被容忍做出一些错误的决策

## Review
+ 文章中的state往往能很好地渲染出图像信息，但是在噪声更多、部分可观察性更明显的情况下能否work不明晰
+ 关于target domain中的数据采集，以及关于数据/behavior policy的假设。这一部分也是CODAS和CycleGan的不同之处，它需要在target domain上的行动序列。

---
+ 现在的任务是，在优化目标中，KL散度一项因为使用的sequential modelling的想法，所以只学习一个反向的映射并不能一定达到散度的最小化。所以对于source domain和target domain，本身我们对两个采样策略的要求就是在这 两个策略下运行最终得到的稳态概率是要相同的
+ 现在的任务：从pre-collected target上的数据推断出一个对应的source domain上的采样策略

1. 使用target data和source data，学习映射函数
2. 这里的source data应当是使用某种采样策略进行产生
3. 我需要学习这种采样策略
4. 同时还有一个decoder
5. 问题是现在只有target上的o，a，o‘

Policy Mismatch
+ 我们现在有一个source上的最优策略，希望学习一个映射，使得将o映射回s，能够最真实地反应这种关系（oracle），也就是目标域上的最优策略和source上的最优策略在具有oracle的时候是一一对应的。
+ 在学习的过程中我们有一些在目标域上 预先采集的数据，也有在源域上预先采集的数据
+ 如果接受最优性假设：
  + 只是训练时的data不同而已
