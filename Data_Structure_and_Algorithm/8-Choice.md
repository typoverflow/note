# 选择算法
## 选择最大值和最小值



## 期望时间为线性时间的算法
+ 问题描述：选出给定的一组数中第i小的元素
+ 方法一：
  + 先排序，再查找，显然复杂度为$\Omega(n\lg n)$
+ 方法二：
  + 分治思想，借用快速排序的思路
  + 注意RandomPartition步骤有切分、分两部分那一些步骤。
  + 首先如果RandomPartition切分点p恰好就是需要寻找的i，那么算法结束，否则如果i小于p，则到A[1...p]中寻找第i小的元素，如果i大于p，则到A[p+1...n]中寻找第i-p小的元素
  ```
    RndSelect(A, i)
    if (A.size=1)
        return A[1]
    else
        q = RandomPartition(A)
        if (i==q)
            return A[q]
        else if (i<q)
            return RndSelect(A[1...(q-1)], i)
        else return RndSelect(A[(q+1)...A.size],i-q)
  ```
  + 复杂度分析
    + 最好$O(1)$
    + 最坏$O(n^2)$，但是不太可能发生。要每次都挑到最大元素的概率非常小
    + 平均情况分析
      + 首先定义一个好划分为这个划分将原数组分成0.8和0.2的规模，显然RndSelect产生这样的划分的概率为0.6
      + 由于每次划分0.8，显然至多进行$\log_{1.25}n$问题规模便会降到1，算法终止
      + 令Ci为上次好划分到第i次好划分这中间的代价，则$C_i=0.8^{i-1}n$
      + 事实上我们期望要1/0.6次才能看到一个好划分,由$E=0.6×1+0.4(1+E)$得出。每次选择有0.6概率直接获得好划分，否则还需要E次才能获得好划分，这一部分总共需要E加上失败的那一次×0.4的代价。因此从上一次好划分到下一次好划分的期望代价$E[C_i]=\Theta(1)0.8^{i-1}n$（每次尝试当前划分是不是好划分都需要Ci的代价，因此是乘号）
      + 因此总的时间复杂度的期望$E(T(n))\leq E[\sum_{i=1}^{\log_{1.25}n}C_i]=\sum_{i=1}^{\log_{1.25}n}E[C_i]=O(n)$
    + 另一种平均情况分析方法
      + Cost on an input of size n <= (cost on an input of size 0.8n)+(cost to reduce input to size <=0.8n)
      + 对上式两边取期望，最后边的期望代价实际上就是从一个好划分到下一个好划分的代价，$\Theta(1)0.8^{i-1}n$
      + $E(T(n))\leq E[T(0.8n)]+O(n)$

## 最坏时间为线性时间的算法
+ 首先将输入数组划分为n/5组
+ 选出每组元素的中位数，复杂度为O(1)
+ 对找出的n/5个中位数，递归调用QuickSelect找出中位数
+ 对平均情况的下界进行分析
    + Median of medians
        ```
        QuickSelect(A, i):
        if (A.size=1)
            return A[1]
        else
            m = MedianOfMedians(A)
            q = PartitionWithPivot(A, m)
            if (i==q)
                return A[q]
            else if (i<q)
                return QuickSelect(A[1...(q-1)], i)
            else 
                return QuickSelect(A[(q+1)...A.size], i-q)
        ```
        ```
        MedianOfMedians(A):
        <G1, G2,...,G5/n> = CreateGroups(A)
        for (i=1 to n/5)
            Sort(Gi)
        M = GetMediansFromSortedGroups(G1, G2, ....G5/n)
        return QuickSelect(M, (n/5)/2)
        ```
    + 复杂性分析$T(n)\leq T(0.7n)+T(0.2n)+O(n)$，得出$T(n)=O(n)$

## 对于选择算法的分析
+ 下界肯定是需要$\Omega(n-1)=\Omega(n)$
+ 上界我们已经证明是$\Omega(n)$
+ 可以作出结论，对于选择算法我们的讨论已经结束
