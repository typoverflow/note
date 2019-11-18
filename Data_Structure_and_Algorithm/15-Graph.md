# 图

## 邻接矩阵：Adjacency Matrix
+ 考虑图G=(V, E), 其中|V| = n, |E| = m
+ 邻接矩阵是n*n矩阵A = ($a_{ij}$) where a_ij = 1 <=>(i, j) in E
+ 空间开销为$O(mn)$

## 邻接列表：Adjacency List
+ 为每个元素建一个链表，将与这个元素相邻的元素全部加入到链表中。
+ 空间开销为$O(n+m)$

## 邻接矩阵和邻接表的对比
+ 邻接矩阵
  + Fast Query：判断u和v是否相邻/查询一条边是否存在
  + Slow Query：列举u的邻居
+ 邻接表
  + Fast Query：列举u的邻居
  + Slow Query：判断u和v是否相邻/查询一条边是否存在

## 图搜索

---
## 计算有向图中的强连通分量和连通分量
+ 对于无向图，答案是显然的：只需要进行BFS/DFS即可
+ 使用component graph将原图按照强连通分量收缩为一个点，并把原本的边合并起来，得到的图称为$G^C$
+ component一定满足下述性质：component graph是一个有向无环图(DAG)
### 计算有向图G的强连通分量SCC
+ 如果我们能从component graph当中的sink SCC开始进行遍历，那么遍历过的点都将是sink SCC中的点
+ 我们将G中的所有有向边进行反向，并画出它的component graph $(G^R)^C$，将问题转化为在$(G^R)^C$中寻找source节点
+ Lemma：for any edge (u, v)  
  TODO(补充引理)
+ 对$G^R$中的节点进行DFS，得到的结束时间最大的节点一定是$G^R$中的source，也就是$G$中的sink，然后在$G^C$中对该节点进行DFS，得到的为$(G^C)$中的sink SCC
+ 去掉该sink SCC后，继续寻找sink SCC即可。由于之前已经对$G^R$进行过遍历，由引理只需要找结束时间最大的节点重复上面一个过程即可。
+ 总的算法过程
  + Compute $G^R$
  + Run DFS on $G^R$ and record finish times $f$
  + Run DFS on $G$ but in DFSALL, process nodes in decreasing order of $f$
  + Each DFS tree is a SCC of $G$
+ 时间复杂度：$O(n+m)
+ 注意点
  + 为什么通过找source的方式寻找sink？因为由结束时间寻找source相较寻找sink更容易