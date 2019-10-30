# 抽象数据类型：Disjoint Sets

## disjoint-set 
+ disjoint-set mantains a collections $\mathbb{S}=\{S_1, S_2,...S_k\}$ of sets that are disjoint and dynamic
+ 每一个集合$S_i$都有一个代表元素(representative/leader)
+ 数据类型Disjoint Set需要满足的操作
  + MakeSet(x):创建一个仅包含x的集合，并把该集合加入到$\mathbb{S}$中
  + Union(x, y):找到包含x和y的集合$S_x,S_y$,在$\mathbb{S}$中删除$S_x, S_y$，将$S_x\cup S_y$加入到$\mathbb{S}$中
  + Find(x):找到包含元素x的集合，返回指向该集合代表元素的指针

## Implementations
---
## 链表
+ Union：平均时间复杂度为$O(\lg n)$
+ $TODO：自己看$

## 树
+ 树的根为集合的leader，同时树的每个节点都维护一个指针，指向其父亲。
+ MakeSet：$\Theta(1)$复杂度
+ Find(x):直接从x节点向上找到根节点即可
+ Union(x, y)找到两个根，然后union。时间开销$O(\lg n)$

### Path Compression
+ 在find操作中，找到根节点后，顺手将路径上所有节点的父节点直接指向根节点
+ 由于path compression会大幅度改变树的结构，因此原来维护的height变量不太好。重新维护一个变量rank，表示排名，每次union后新的根节点rank++