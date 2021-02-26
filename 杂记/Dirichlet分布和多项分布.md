# Dirichlet分布和多项分布
+ 这部分知识看过很多次但都没有记住，遂决定记录下来

## 多项分布
+ 考虑在一次随机试验中，情况$1, 2, 3, ..., k$出现的可能性分别为$P_1, P_2, P_3, ..., P_k$，则在$N$次独立随机试验中，这$k$种情况各出现$(N_1, N_2, ..., N_k)$次的概率为
  $$P(N_1, N_2, ..., N_k)=\frac {N!}{\prod_{i=1}^k N_i!}\prod_{i=1}^k P_i^{N_i}$$
  其中$N=\sum_{i=1}^{k}N_i$

## Dirichlet分布
+ 令$\alpha=\sum_{i=1}^{k}\alpha_1+\alpha_2+...+\alpha_k$，对连续变量$X=(X_1, X_2, ..., X_k), X_i\in(0, 1)$，其概率密度函数为
  $$Dir(X|\boldsymbol{\alpha})\frac {\Gamma(\alpha)}{\prod_{i=1}^k \Gamma(\alpha_i)}\prod_{i=1}^k X_i^{\alpha_i-1}$$

## 多项分布与Dirichlet分布之间的关系
+ 对多项分布进行参数估计。假设有一系列样本$ \mathcal{D} $，其中情况$1,2,...,k$出现的次数分别为$N_1, N_2, ..., N_k$，则由多项分布可得似然函数为
  $$L(\mathcal{D}|\boldsymbol{P})=\prod_{i=1}^k P_i^{N_i}$$
  由贝叶斯公式
  $$
  \begin{aligned}
      Pr(\boldsymbol{P}|\mathcal{D})&=\frac{Pr(\mathcal{D}|\boldsymbol{P})Pr(\boldsymbol{P})}{Pr(\mathcal{D})}\\
      &=\frac{Pr(\mathcal{D}|\boldsymbol{P})Pr(\boldsymbol{P})}{\int Pr(\mathcal{D}|\boldsymbol{P})\mathrm{d} \boldsymbol{P}}\\
  \end{aligned}
  $$
  在此不对$ \boldsymbol{P} $的先验分布作出假设，认为等于$1$，因此进一步有
  $$
  \begin{aligned}
      P(\boldsymbol{P}|\mathcal{D})&=\prod_{i=1}^kP_i^{N_i}\frac 1{\int \prod_{i=1}^kP^{N_i}_i\mathrm{d}\boldsymbol{P}}\\
  \end{aligned}
  $$
  分母上的积分结果为
  $$\int \prod_{i=1}^kP^{N_i}_i\mathrm{d}\boldsymbol{P}=\frac {\Gamma(N+k)}{\prod_{i=1}^{k}\Gamma(N_i+1)}$$
  令$\alpha_i=1+N_i$代入$P(\boldsymbol{P}|\mathcal{D})$，得
  $$
  \begin{aligned}
      P(\boldsymbol{P}|\boldsymbol{D})&=\frac {\Gamma(\alpha)}{\prod_{i=1}^k\Gamma(\alpha_i)}\prod_{i=1}^k P_i^{\alpha_i-1}\\
      &=Dir(\boldsymbol{P}|\boldsymbol{\alpha})
  \end{aligned}
  $$
  由此可发现，**多项分布的参数分布恰恰为狄利克雷分布。**