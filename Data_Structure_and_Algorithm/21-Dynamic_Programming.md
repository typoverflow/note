# 动态规划 Dynamic Programming

## 动态规划
+ 考虑一个优化问题
  + 逐步建立最优解
  + 要求问题具备最优子结构性质
    + 最优子结构性质保证了递归解的存在
  + 在递归方法中存在大量重复解决子问题的现象
    + 使用带有备忘机制的递归算法，或
    + 找到**合适顺序**，逐个解决子问题
      + 合适的顺序指，在解决某个子问题时，其所依赖的子问题都已被解决。
+ Floyd-Warshall算法实际上也是**自底而上**的动态规划算法，dist数组即为备忘机制，并且问题的解决顺序为r的增大顺序。

## 构造DP算法
+ 考虑好解的递归结构
  + E.g.:【Rod-Cutting】：(one cut of length i)+(solution for length n-i)
+ 建立备忘机制
+ 由最优子结构性质，得到最优解的结构
  + 实际上就是在解决各个子问题的假设下，怎样从子问题的解得出原问题的最优解
  + 【Rod-Cutting】：取最大的一种情况
+ 使用自底而上（递归）或自上而下（迭代）方法，设计算法计算最优解的值
  + Top2Down or Bottom2Up
+ 得出最优解的详细构造
  + 记录下最优解的各个选择

---
## The Rod-Cutting Problem
+ Assume we are given a rod of length n, We sell length i rod for a price $p_i$, where $i\in\mathbb{N}^+$ and $1\leq i\leq n$
+ 如何切割钢条才能最大化利润？

### 贪心算法
+ 令$r_k$为长度为k的钢条能获得的最大利润
+ 贪心策略为每次选择单位长度利润最高的割法
+ 最优子结构性质显然满足：$r_n = max(p_i+r_{n-i})$
+ 贪心选择性质不能满足，类似于0-1背包问题
  + 考虑n=3, p1=1, p2=7, p3=9作为一个特例

### 递归算法
+ 使用分治思路
```python
CutRodRec(prices, n):
if n==0
    return 0
r = -INF
for i=1 to n
    r = Max(r, prices[i]+CutRodRec(prices, n-i))
return r
```
+ 时间复杂度为$O(2^{n-1})$.(考虑每个单位长度处是否要去切割)  
  ![](img/2019-12-05-02-19-09.png)

### 动态规划方法
#### 递归版本
+ 引入备忘机制，记住每个已被解决的子问题
```python
CutRodRecMem(prices, n):
for i=0 to n
    r[i] = -INF
return CutRodRecMemAux(prices, r, n)

CutRodRecMemAux(prices, r, n):
if r[n]>0
    return r[0]
if n==0
    q = 0
else
    q = -INF
    for i=1 to n
        q = Max(q, prices[i]+CutRodRecMemAux(prices, r, n-i))
r[n] = q
return q
```
+ 时间复杂度为$O(n^2)$
+ 图形解释
  + ![](img/2019-12-05-02-13-59.png)
  + 该图一定是有向无环图
  + 解决该问题的思路类似于DFS

#### 迭代版本
+ **要想转换为迭代版本，我们要找到一种顺序来依次解决各个子问题，使得在解决某个子问题时，它所依赖的其他子问题都已被解决**
+ **按照逆拓扑排序的顺序解决子问题！**
```python
CutRodIter(prices, n):
r[0] = 0
for (i=1 to n)
    q = -INF
        for j=1 to i
            q = Max(1, prices[j]+r[i-j])
        r[i] = qreturn r[n]
```
+ 时间复杂度仍然为$O(n^2)$
+ 然而上述算法仅能得出最大利润，却无法给出切割方案。因此可进一步改进
```python
CutRodIter(prices, n):
r[0] = 0
for i=1 to n
    q = -INF
    for j=1 to i
        if (q<prices[j]+r[i-j])
            q = prices[j]+r[i-j]
            cuts[i] = j
    r[i] = q
return r[n]

PrintOpt(cuts, n):
while n>0
    Print cuts[n]
    n = n-cuts[n]
```

---
## 矩阵乘法
+ INPUT: Matrices $A_1, A_2, ..., A_n$,$A_i$的大小为$p_{i-1}\times p_i$
+ OUTPUT: $A_1A_2...A_n$
+ PROBLEM: 用最小的代价计算乘法结果
+ 按照不同的结合律进行计算的代价是完全不同的

#### 动态规划算法
+ 找到解的递归结构
  + 最后一步可被看作$(A_1A_2...A_k)\cdot(A_{k+1}A_{k+2}...A_n)$
  + 因此中间的任何步骤都可被看作$(A_iA_{i+1}...A_k)\cdot(A_{k+1}A_{k+2}...A_j)$
+ 建立备忘机制
  + 令$m[i, j]$表示计算$A_i...A_j$的最小代价
+ 找到最优解的递归结构
  + $m[i, j] = min_{1\leq k < j}(m[i, k]+m[k+1, j]+p_{i-1}p_kp_j)$
+ 计算最优解的值
  + Top-Down(recursion with memorization), easy.
  + Bottom-Up
    + 可以按照从每个对角线向右走一只走到右边的方法
    + TODO（补图）
```python
MatrixChainDP(A1, A2, ..., An):
for i
```
TODO(完善上述代码)
+ 构造最优解
  + 添加数组s用于记录在计算$A_i...A_j$时我们所选择的k

## 编辑距离（Edit Distance）
+ Given two strings, how similar are they?
+ Edit Distance of A and B is defined as **# of ops to transform A to B**
  + ops$\in$
    + Insertion: insert a character at a position
    + Deletion: delete a character at a position
    + Subtitution: change a character to another one

#### 动态规划算法
+ 找到解的递归结构
  + TODO（补充Step1内容）
+ 建立备忘机制
  + dist(i, j)表示A[1...i]和B[1...j]之间的edit distance
+ 找到最优解的结构
  + TODO(补充Step2的内容)
+ 计算最优解的值
  + Bottom-Up：从左到右从上到下遍历网格即可  
    TODO（补图）
TODO（补充算法代码）
+ 构造最优解

## 最大独立集
+ Given an undirected graph G=(V, E), an independent set I is a subset of V, such that no vertices in I are adjacent
+ A maximum independent set (MaxIS) is an independent set of maximum size
+ 下面考虑以r为根的树的最大独立集

#### 动态规划算法
+ 解的递归结构
  + Given an IS of T, for each child u of r, set $I\cap V(T_u)$ is an IS of $T_u$
+ 设计备忘录
  + let $mis(T_u, 1)$ be the size of MaxIS of $T_u$ s.t. u in the MaxIS
  + let $mis(T_u, 0)$ be the size of MaxIS of $T_u$ s.t. u NOT in the MaxIS
+ 最优解的递归结构
  + $mis(T_u, 1) = 1+\sum_{v\ is\ a\ child\ of\ u}mis(T_v, 0)$
  + $mis(T_u, 0) = \sum_{v\ is\ a\ child\ of\ u}mis(T_v)$
  + $mis(T_u) = max\{mis(T_u, 0), mis(T_u, 1)\}$
+ 计算最优解的值
  + 递归算法
    + TODO（补充递归结构的算法）
  + 迭代算法
    + 是不是可以使用DFS，然后按照结束时间先后计算各节点？


