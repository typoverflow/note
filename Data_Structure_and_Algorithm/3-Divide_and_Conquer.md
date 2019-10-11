# Divide and Conquer

## Merge-sort
+ 略
+ 时间复杂度：$\Theta(n\log n)$
+ 空间复杂度：$\Theta(n)$
  
## Merge-sort Iterative
```
Deque Q;
for (i=1 to n)
    Q.AddLast(A[i]);
while (Q.Size()>1)
    L=Q.RemoveFirst();
    R=Q.RemoveFirst();
    Q.AddLast(Merge(L, R))
return Q.RemoveFirst()
```

## Integer Multiplication
+ 平凡算法的时间复杂度为$\Theta(n^2)$
+ 分治算法
  + $$x = 2^{\frac{n}{2}}*x_L+x_R$$
  + $$y = 2^{\frac{n}{2}}*y_L+y_R$$
  + $$xy = 2^n*x_Ly_L+2^{\frac{n}{2}}*(x_Ly_R+x_Ry_L)+x_Ry_R$$
  + 递归复杂度：$T(n)=4T(n/2)+O(n)$
  + 时间复杂度为$O(n^2)$
+ 改进分治
  + 将xy表达式中的$x_Ly_R+x_Ry_L$换为$(x_L+x_R)(y_L+y_R)-x_Ly_L-x_Ry_R$.后面的减数可一起计算，由此简化计算复杂度。
  + 递归复杂度：$T(n)=3*T(n/2)+O(n)$
  + 时间复杂度变为$(\frac32)^{\lg{n}}n$也就是$o(n)$

## Matrix Multiplication
+ 平凡算法：$\Theta(n^3)$
+ 将矩阵分块，最后发现时间复杂度还是$\Theta(n^3)$
+ 更高阶技巧：略
  + 递推复杂度：$T(n)=7T(\frac n2)+O(n^2)$

**注意**：以后如果要在作业本上写过程，可以先通过递归树来猜测复杂度的表达式，然后使用数学归纳法来证明。有时候需要调整，添上低次项。因为低次项实际上也出现在了递推式中。先用待定系数法待定高次项以及低次项的系数，然后结合条件定出在哪些d、d_prime下归纳过程能够成立。T

## 递归树证明法
+ 以$T(n)=3T(n/4)+\Theta(n^2)$为例
+ 第一层merge的代价为$cn^2$，第二层为$3*c(\frac n4)^2=(\frac 3{16})^2cn^2$......最后一层$(3/16)^{\log _4{n-1}}cn^2$
+ 最后一层总共有$3^{\log_4n}=n^{\log_43}$个节点，需要$\Theta(n^{\log_43})$时间解决
+ 总共的时间复杂度为$T(n)=\sum_{i=0}^{\log_4{n-1}}(\frac3{16})^icn^2+\Theta(n^{\log_4 3})=\frac{(3/16)^{\log_4n}-1}{(3/16)-1}cn^2+\Theta(n^{\log_43})$  
  取左边几何级数的上界16/13，得到
  $$T(n) = O(n^2)$$
+ **关于递归树最后一层的节点数：两种计算方法，一个是用幂次做出估计，还有一个是根据实际情况**
  + 例子一：$T(n)=3T(n/4)+\Theta(n^2)$  
  最后一层的节点总数为$3^{\log_4n}=n^{\log_43}$个节点
  + 例子二：$T(n)=T(\alpha n)+T((1-\alpha)n)+cn$  
  最后一层的节点总数肯定不多于$n$个节点。因为无论怎么分割，子节点的规模之和和父节点都是相同的。这样子得到的子节点数量比一般的幂次估计得到的答案更加接近。

## 主定理
+ 令$a\geq1,b\geq1$是常数，$f(n)$是一个函数，$T(n)$是定义在非负整数上的递归式：
  $$T(n)=aT(n/b)+f(n)$$
  那么$T(n)$有如下渐近界：
1. 若对某个常数$\epsilon>0$有$f(n)=O(n^{\log_b^{a-\epsilon}})$，则$T(n)=\Theta(n^{\log_ba})$
2. 若$f(n)=\Theta(n^{\log_ba})$，则$T(n)=\Theta(n^{\log_ba}\lg n)$
3. 若对某个常数$\epsilon>0$有$f(n)=\Omega(n^{\log_ba+\epsilon})$，且对某个常数$c<1$和足够大的n有$af(n/b)\leq cf(n)$,则$T(n)=\Theta(f(n))$
4. 如果$f(n)=\Theta(n^{\log_ba}\lg^kn)$，其中$k\geq0$，则$T(n)=\Theta(n^{\log_ba}\lg^{k+1}n)$  
   **情况4处于情况2和情况3之间的区域！**


## Peak finding
+ 找到中间元素
+ 控制边界条件
+ 比较左右两边的元素，如果左右两边的元素均比中间元素小，返回中间元素；否则减去比较小的一支，并返回另一支。
+ 递归步骤
+ 最终找到的一定是数组中的某个极值。找到局部极值实际上只需要$O(lg n)$，而找到全局极值需要至少$\Omega (n)$的时间
+ 证明算法正确性——首先证明会停机，在证明会返回正确结果。

## Peak finding in 2D
+ 方法一：将每一列视作一维数组，并且使用找出每一列的最大元素。然后在得到的新的一行元素去使用Peak finding。复杂度为$O(n^2)$
+ 方法二：
  + 找到中间一列并找出这一列的最大元素
  + 检查这个元素是否为Peak，若是返回，若不是砍掉较小的那一半的所有列，向更大的那一半边继续递归上述步骤。
  + 这实际上也是Divide and Conquer算法，不断细分矩阵，并且不断解决问题，最后细分完成时得到答案。
  + 算法复杂度：$T(n,n^\prime)\leq T(n/2, n^\prime)+O(n^\prime)$
  + $T(n, n^\prime)=(\lg n)\dot O(n^\prime)=O(n\lg n)$
+ 方法三：
  + 画一个十字形，检索十字形和上一次迭代的边缘的最大值
  + 如果已经是极大值，返回这个值；否则找到更大的元素被包含的象限，返回这个象限并递归。
