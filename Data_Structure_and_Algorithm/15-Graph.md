# 

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
+ BFS
+ DFS
