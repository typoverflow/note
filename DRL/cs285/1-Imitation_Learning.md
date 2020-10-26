# Imitation Learning

## DAgger
+ 算法流程
  + train $\pi_\theta(a_t|o_t)$ from human data $ \mathcal{D}=\{o_1, a_1, ..., o_N, a_N\} $
  + run $\pi_\theta(a_t|o_t)$ to get dataset $ \mathcal{D}_\pi =\{o_1,  ..., o_m\}$
  + Ask human to label $ \mathcal{D}_\pi $ with actions $a_t$
  + Aggregate: $ \mathcal{D}\leftarrow \mathcal{D}\cup \mathcal{D}_\pi $

## Why might we fail to fit the expert
+ Distrubution mismatch problem
  + Use **on-policy** algorithms like DAgger
+ Non-Markovian behavior
  + stack frame to generate a sequence of history observations?
    + **Why sophisticated models works poorly for behaviour cloning?**
      + 实际上考虑历史信息的模型在行为克隆任务上表现并不好
      + 历史信息会带来大量“causal confusion”问题，也就是模型难以从过去一段历史序列中各种事件中选择出真正和目标具有因果关系的那一个
    + 实际上DAgger算法能够较好地解决这一问题
+ Multimodal behavior
  + 在同一个观察下可选择的行动往往不同，如果使用连续分布来表示，在聚合分布时可能会导致出现不预期的结果。做法是使用比高斯分布更复杂的分布表示或者使用类似tabular的离散表示
  + 方法
    + Output a mixture of Gaussians
    + Latent variable models
    + Autoregressive discretization

## Another way: reverse learning
+ 我们可以通过优化奖赏函数的方式，使得奖赏值分布接近专家数据中的行动偏好分布，类似Reverse Reinforcement Learning