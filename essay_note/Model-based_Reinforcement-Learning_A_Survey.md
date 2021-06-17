# Model-based Reinforcement Learning: A Survey

+ Section 4: dynamic model learning: challenges, uncertainty, partial observability and temporal abstraction
+ Section 5: how to integrate planning and learning
+ Section 6: implicit approach to model-based RL
+ Sectoon 7: potential benefits of model-based reinforcement learning

## Chapter 3: Categories of Model-based Reinforcement Learning
+ planning和learning的区别：planning需要reversible access to the MDP（可以理解为在某一点不断反复重复实验），这导致planning导出的解和learning导出的解完全不同：
  + planning的解是local，atomic的
  + learning的解是global的

## Challenge 4: Dynamics Model Learning
+ Type of Model
  + Forward Model: $(s_t, a_t)\rightarrow s_{t+1}$
  + Inverse Model: $\left(s_{t}, s_{t+1}\right) \rightarrow a_{t}$

### Stochasticity
+ 给定状态动作对之后，下一个状态服从某种分布
+ 我们可以使用两种model（P8）
  + descriptive model：描述next state的分布，比如Gaussian，tabular，高斯混合，但它们在拓展到高维空间时表达能力不够
  + generative model：variational inference，GAN，flow-based model

### Uncertainty
+ 因为样本的稀缺性而导致的不确定性，和随机性的区别在于，Uncertainty可以通过观察更多数量的样本得到解决

### Partial observability
部分可观察性
  + Windowing，类似DQN
  + Belief states，将环境模型分为观察模型和转移模型
  + Recurrency

### Non-stationarity
略

### Multi-step prediction
略

### State abstraction
+ 最常用的方法：AE
  + encoder
  + planning over latent variables
  + decoder
+ 如何确保模型在latent variable层面进行规划？
  + 使用一个loss term，该损失项衡量模型输出的下一个状态的隐变量和ground truth的encode之后的距离
+ Object-oriented planning
  + 使用GNN来捕捉物体之间的相互作用与关联
  + 或者可以使用额外的loss项（13）
    + 比如$s_{t+1}-s_t$，将让Agent关注能够移动物体的动作
    + contigency awareness，识别出能够移动的物体

### Temporal abstraction
+ 通常意义下就是指代HRL
  + option framework
  + universal value function approximators - Goal conditioned policy/value functions
+ 在分层中，比较重要的内容是如何识别相关的sub-routines
  + 根据图结构：识别bottlenecks状态
  + state-space coverage/compression
  + reward_relevancy: 代表算法有option-critic，但是在这种框架下如何保证diversity就是一种问题

## Integration of Planning and Learning

### At which state to start planning?
+ random：难以扩展到高维
+ visited：比如Dyna
+ Prioritized
+ Current：比如Alpha-Zero

### How much budget do we allocate for planning and real data collection?
+ Dyna: 100
+ AlphaZero: ~320,000
+ *squeezing approach*: plan直到收敛得到最优策略，充分利用了当前模型的所有可利用信息
+ 自适应调整规划次数：
  + 可以考虑基于Q估值的方差的方法，当Q的方差较大时，选择更多来自模型的样本

### How to search?
+ 关于planning方法的讨论
  + Discrete planning
    + probability-limited search, breadth-limited search, Monte Carlo search, MCTS, min-max search, etc
  + ==Differential planning（20）==
    + 如果模型是可导的，那么就可以使用可微规划的方法进行规划
    + 注意这里讨论的实际上仍然是规划的方法，而并不涉及使用model gradient对强化学习的其他部分进行优化
+ Direction
  + Forward
  + ==Backward：$(s'\rightarrow s,a)$（20）==
    + Prioritized Sweeping：如果某个状态$s'$的状态值变化较大，那么它的前驱状态动作对往往是急需更新的位置
    + ==是不是也可以作为meta buffer的motivation之一？==
+ Dealing with uncertainty
    + Data-close planning: 要求模型产出的数据分布在样本附近
    + uncertainty propagation（23）
      + ==focus on the propagation of uncertainty over timesteps==

### How to integrate planning in the learning and acting loop
+ Planning input from learned functions
  + Value priors / policy priors: 将学习得到的值函数/策略先验作为规划过程中对状态值/策略更为准确的估值
+ Planning update for policy or value update
  + 感觉像是使用规划的结果（比如树搜索完后根节点下各子节点的值）构造policy/value update的更新目标

## Implicit Model-based Reinforcement Learning
+ combining learning of models as planning
  + TreeQN: 使用transition model作为MCTS中展开搜索树的方式，这样就形成了一个端到端可微的MCTS搜索树，然后进行优化

## Benefits from Model-based RL
+ On exploration（36）
  + ==Value-based versus state-based exploration: 有了模型之后可以考虑基于state进行探索，和uncertainty based exploration很想，具体可以参考intrinsic motivation==
  + 有关intrinsic motivation，首先要提一下关于exploration的区分
    + shallow vs deep exploration: shallow exploration会在每个时间步都进行独立的探索，这可能会导致探索的退化。deep exploration旨在correlate decision over multiple timesteps。但是注意，就算我们使用model进行deep的exploration，在最后执行的时候Agent仍然是只执行第一步，因此最终的执行过程仍然可能是退化的
    + task-conflated versus task-seperated exploration back-ups. 添加intrinsic会导致全局最优解发生变化