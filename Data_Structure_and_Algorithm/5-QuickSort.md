# Quick Sort
+ 在A中选择一个元素作为pivot
+ 利用pivot把原数组剩下的元素划分为两组B，C，使B中元素小于pivot，C中元素大于pivot
+ 递归
+ 返回\<B,x,C\>

## 选择pivot
+ 理想情况下pivot应该能把数组元素划分为大小大致相等的两组元素

## 划分
+ 用与数组等长的空间，用p_l和p_r分别从左到右和从右到左放数。
  + 开销
  $$T(n)=\Theta(n)$$
  $$S(n)=\Theta(n)$$
+ 改进：inplace sort
  + ```c++
    InplacePartition(A,p,r)
    x = A[r], i=p-1
    for (j=p to r-1)
        if (A[j]<=x)
            i++
            Swap(A[i], A[j])
    Swap(A[i+1], A[r])
    return i+1
    ```
  + 实际上每次都把较小的元素压到了数组的左边
  + 开销$T(n)=\Theta(|r-p|)$
  + 不稳定

# 总体分析
+ 实际上pivot选择的好坏决定了递归树的高度
+ 最差情况下，$T(n)=max_{0\leq q\leq n-1}(T(q)+T(n-q-1)+cn$
+ 最好情况下，$T(n)\leq 2T(n/2)+\Theta(n)$
  + 实际上只要我们选出的pivot能够将n分成固定常数比例的两部分，也就是$T(n)=T(dn)+T((1-d)n)+\Theta(n) where\ d=\Theta(1)$
+ 平均状况下，