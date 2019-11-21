# Minimun Spanning Trees(MST)
+ Consider a connected, undirected, weighted graph G
+ A ***spanning tree*** is a tree containing all nodes in V and a subset T of all edges E
+ A ***minimim spanning tree*** is a spanning tree whose total weight $w(T)=\sum_{(u, v)\in T}w(u, v)$ is minimized

## 寻找最小生成树
### Generic method for computing MST
+ 从所有节点和空的边集A开始
+ 找到一条safe edge加入A，满足加入这个safe edge后A仍然是MST的边集的子集
+ 重复上述过程
+ 下面讨论如何找到这样的safe egde

### 定义
+ 割(**cut**)：A cut (S, V-S) is a partition of V into two parts
+ An edge **crosses** the cut (S, V-S) if one of its endpoints is in S and the other is in V-S
+ A cut **respects** an edge set A if no edge in A crosses the cut
+ An edge is a **light edge** crossing a cut if the edge has minimum weight among all edges crossing the cut
+ ***Thm【Cut Property】:Assume A is included in the edge set of some MST, let (S, V-S) be any cut repecting A. If (u, v) is a light edge crossing the cut, then (u, v) is safe for A***.(consider the process of generating MST steps by steps!)
  + TODO(补充证明)
+ ***Corollary:Assume A is included in some MST, let $G_A$ = (V, A), then $G_A$ is a forest. Then for any connected component in $G_A$, its minimum-weight-outgoing-edge(MWOE) in G is safe for A***.
+ in $G_A$, an edge in a CC is outgoing if it connects to another CC.

### Kruskal's Algorithm
+ 不断找到能够连通$G_A$中的两个不同连通分量的权重最小的边
+ 实际上应用的就是cut property
+ 其中需要使用并查集进行连通分量的判断
+ TODO(补充伪代码)
