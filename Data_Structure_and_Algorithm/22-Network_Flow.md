# Network Flow 网络流问题
+ Consider a network with capacity constraints on edges, given a source and a sink(target) t, what is the maximum flow from s to t?
+ A **flow network** is a directed graph $G=(V, E)$ where each edge has a *capacity* $c(u, v)\geq 0$
+ A **flow** in G is a function $f:V\times V\rightarrow R$ satisfying
  + **【Capacity constraint】：For every $(u, v)\in E$, $0\leq f(u, v)\leq c(u, v)$**
  + **【Flow conservation】：For every $u\in V-\{s, t\}$:$\sum_{v\in V}f(v, u)=\sum_{v\in V}f(u, v)$**
+ TODO(补充问题描述)

## 算法思想
+ 从一个可行解开始，逐步增强到最优解
### Simple Algorithm
+ 从s开始，找到一条到 t 的路径，找到这条路径上的流量限制，生成一个s到t的流f
+ 在原图上减去f（路径各边减去使用的流量）
+ 再找到一条s到t的路径，重复上述步骤直到找不到这样的路径
+ TODO（补充过程）
+ 然而Simple Algorithm只能得到可行解，而无法得到最优解

### Residual Network
+ 给定一个flow network $G=(V, E)$ 和流 $f$, 残余网络被定义为$G_f = (V, E_f)$，其中$E_f = V\times V$，并且边的constraint满足:
  + TODO(补充Cf定义)
+ 在残留网络$G_f$找到从$s$到$t$的流$f'$，流$f'$可用于增强原网络中的流$f$
  + TODO(补充叠加过程)
### “增强”证明
+ **【Lemma】：$(f\uparrow f')$ is a flow in G, and $|f\uparrow f'|=|f|+|f'|$**
+ TODO(补充证明) 

## Ford-Fulkerson Algorithm
+ TODO(补充文字说明)
```python
FordFulkersonMaxFlow(G, s, t):
Initialize flow f to value 0
while there is an augmenting path p in Gf
    Augment flow f along path p
    Update Gf
return f
```
+ TODO(补充图片)

### Ford-Fulkerson算法正确性证明
+ 定义Cut: A cut of flow network G=(V, E) is a bipartition (S, T) of V such that $x\in S$ and $t\in T$, $S\cup T=V$ and $ST=\emptyset$
+ TODO(补充关键定义)
+ **【Lemma】：Given a flow f in a flow network G, let $(S, T)$ be any cut of G, then $|f|=f(S, T)$**
+ 【Corollary】。。。TODO（）
+ **【Theorem】：The following three conditions are equivalent:**  
  **(a) Flow f is a max-flow G**  
  **(b) Residual graph $G_f$ has no augmenting path**  
  **(c) $|f|=c(S, T)$ for some $cut(S, T)$ of $G$**
+ TODO
