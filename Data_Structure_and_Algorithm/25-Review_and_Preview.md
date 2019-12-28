# 复习和预习，以及一些其他的算法
## 这学期学了啥
+ Some important data structures...
  + list, stack, heap, graph...
  + hash tables, BST...
+ some classical algorithms
  + sorting and selection, ...
+ basic algorithm design and analysis techniques
  + induction, asymptotics, notations, ...
  + recursion, divede-and-conquer ...
+ basic complexity theory
  + P, NP, NPC...
+ **use computers to efficiently solve practical problems!**

## 近似算法
+ 许多问题都是NP-hard，寻找最优解很困难...
+ 因此作为折中(trade-off)，可以寻找一个相对高效但是近似最优的解
### Approximation Ratio
+ 令$P$为最小化问题，$I$为它的一个实例
+ 令$A$为问题$P$的一个近似算法
+ 令$sol_A(I)$为算法$A$为实例$I$返回的解
+ 令$val(sol)$为解$SOL$的目标值
+ 令$opt(I)$为该实例问题的最优解的目标值
  + $opt(I)$仅依赖于输入问题的实例，而不依赖于具体算法
+ 算法$A$的approximate ratio定义为$\max_I {\frac{val(sol_A(I))}{opt(I)}}$

### 贪心策略和近似算法
+ **Greedy solution is close to optimal!**
+ 回忆贪心算法一章中的set cover问题
  + set cover问题是NPC问题，但是它的贪心算法能在$O(\lg n)$时间返回近似解

### 具体问题：Bin Packing
+ 问题描述
  + 有n个物体，各自大小为$s_1, s_2, ..., s_n$，$0<s_i\leq 1$，并且有很多大小为1的桶
+ 若要打包所有的物体，求解所需使用的桶的最少数目。

#### 一种近似算法
+ 将所有物体以任意顺序排列
+ 对每个物体$s_i$
  + 尝试将它放入一个已被打开的桶中
  + 否则，打开一个新桶并把$s_i$放入这个新桶中
  
#### 算法分析
+ 【Lemma】如果我们最终使用的桶的数量为l，那么一定有大于等于$l-1$个桶中被使用了超过一半的容量
+ TODO

#### 算法改进
+ 在第一步排序时，将各个物体按照体积降序排序
+ **【Lemma2】：Let $s_i$ be the first item in $SOL$ put in bin $l+1$, $s_i\leq 1/3$.**
  + TODO
+ **【Lemma3】：Assume optimal solution $OPT$ uses $l$ bins and FFD solution $SOL$ uses $l'$ bins, then in SOL at most $l-1$ items are in bins $l+1$ to $l'$**
  + TODO(补充反证证明)
+ 由Lemma1，在额外使用的桶中装载的每个物体都不会太大；由Lemma2，需要在额外使用的桶中装载的物体数量也不会太多。
+ 因此，FFD给出的解$SOL=l+\lceil\frac{l-1}3\rceil\leq l+\frac{l+1}3=\frac{4l+1}3$
+ TODO(补充近似比)

## 随机算法
### TODO（补充扔球的问题描述）
#### Chernoff Bounds
+ 参见概率论ch6，chernoff方法一节
+ For independent r.v.$X_1, X_2, ..., X_n\in\{0, 1\}$, let $X=\sum_{i=1}^nX_i$, and $\mu=\mathbb{E}(X)$, then
  + for $0<\delta<1$
    + TODO
#### 负载均衡
+ TODO（）

## 在线算法 online algorithm
+ 如果一个算法的输入可以“一块一块”地给出，而不是一次性全部给出，那么这个算法是online algorithm
+ 例如
  + 插入排序是 online algorithm
  + 选择排序是 offline algorithm

### 简单采样问题：Simple Sampling Problem
+ 问题描述：Sample k items out of n items uniformly at random, your algorithm should only use $O(k)$ space. n is very large.
+ 实际上难点在于保证每个物体被采样到是等可能的

#### 简单版本
+ 在[1, n]中选择k个不同的样本即可

#### 复杂版本：Reservoir Sampling
+ 若n未知，并且每一个物体是按照流水线形式逐个传输给算法的
+ 保留前k个传输过来的物体
+ 对于每个大于k地物体i，以$k/i$的概率保留物体i
+ 如果保留了物体$i$，在当前保留的物体中随机挑选一个，用物体$i$替换之。

##### 证明
+ 需要证明每个物体被保留的概率均为$k/n$
+ Basis：$n<k$时显然正确
+ Hypothesis：设假设对于从n个样本中采样的情形成立
+ Inductive Step：当从(n+1)个物体采样时
  + 第(n+1)个元素被保留的概率显然是$k/(n+1)$
  + 对于前面的n个元素，它在第$n+1$次判断后仍被留下的概率是$\frac kn ((1-\frac k{n+1}))$
  + TODO(compete the formula)

### 秘书问题：The Secretary Problem
+ 问题描述略
#### 框架
+ 首先面试前k个并拒绝所有人。然后面试剩余的面试者，如果遇到比前k个面试者中最高分还要高的面试者，则聘用该面试者。
#### k的选择
+ 下面选择k使得能够以最大的概率得到全局最优解
+ 定义
  + 事件$S$：成功雇佣了分数最高的应聘者
  + 事件$S_i$：分数最高的应聘者为第i个面试者，并且我们成功雇佣了该面试者
  + 事件$B_i$：分数最高的应聘者为第i个面试者
  + 事件$O_i$：
  + TODO

## 并行和分布式算法：Distributed Algorithm
+ 共享内存模型
  + TODO（补充图像）
+ 消息传递模型
  + TODO(补充模型)
+ 复杂度度量
  + **时间复杂度**：完成计算任务所需要的轮数。事实上在分布式算法中我们更关心各计算节点之间用于传输消息所消耗的时间（即轮数），而忽略完成本地计算的事件
  + **通信复杂度**：需要在各个计算节点之间传输的消息的数量
  + **空间复杂度**：完成计算任务需要的空间
  + **可行性**：能否解决给定的任务
    + 例如，在同步环境中的环状网络中，确定性算法是不能解决领导人选举问题的
+ 分布式计算的困难点
  + **通信**：尽管忽略了本地计算的代价，但是相互通信的代价还是存在
  + **同步性**：synchrony
  + **容错**：容错性更高，单个计算节点的错误代价可以被降低甚至纠正
  + **局部性**
  + **对称打破**
+ 分布式算法中可能出现的失败(failure)
  + TODO（）

### 共识问题：Consensus
+ 问题描述：一系列节点都有各自的初始值$v_i$，要求让这些节点都输出同一个值。
+ 要求：
  + Termination：每个节点最终都会输出某个值
  + Agreement：每个节点输出同一个值
  + Validity：每个节点最终输出的值是某个节点的初始值

#### 算法
+ 如果没有failure
  + 只需要让所有节点都把自己的初始值发送给所有其他节点，并根据一定机制（比如选取最小值）选举出共同值即可
+ 如果存在 crush failure
  + 设至多
  TODO