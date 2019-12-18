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