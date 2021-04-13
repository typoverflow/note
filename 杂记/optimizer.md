# optimizer

## Gradient Descent (GD)
+ 对于多元函数$f(\boldsymbol{\theta})$，对于其参数$ \boldsymbol{\theta} $求偏导数，然后令其参数向梯度方向位移。
  $$\theta_{t+1}=\theta_t-\alpha \nabla_{\alpha}J(\theta)$$
+ 特点：<u>适合求解无约束问题</u>

## BGD SGD
+ BGD会使用所有样本的梯度均值作为最终优化器的梯度
  $$\theta_{t+1}=\theta_t-\alpha_t\cdot\frac 1n\cdot \sum_{i=1}^n \nabla_{\theta}J_i(\theta, x^i, y^i)$$
  由于需要计算样本的平均梯度，因此计算速度较慢，但是训练稳定，一定程度上能收敛到最优解

```python
# in PyTorch
torch.optim.SGD(params, lr=<required parameter>, momentum=0, dampening=0, weight_devay=0, nesterov=False)
```

+ 特点：<u>SGD每次从样本集中选取一个样本计算梯度，因此训练速度很快，但是波动性很大</u>

## 动量优化方法
### Momentum
+ 在SGD的基础上，参数更新时一定程度上保留之前的方向，但是又利用当前Batch的梯度对方向进行微调
  $$
  \begin{aligned}
    m_{t+1}&=\mu\cdot m_t +\alpha \nabla_{\theta}J(\theta)\\
    \theta_{t+1}&=\theta_t-m_{t+1}
  \end{aligned}
  $$
+ 在PyTorch中，设置SGD的`momentum`参数不为0即可启用动量优化
+ 特点：<u>能够加速SGD的收敛，稳定SGD的训练过程</u>

### Nesterov Accelerated Gradient
+ 在Momentum的基础上，将当前时刻的梯度$\nabla_{\theta}J(\theta)$更改为$\nabla_\theta J(\theta - \mu m_t)$
  $$
  \begin{aligned}
    m_{t+1}&=\mu\cdot m_t +\alpha \nabla_{\theta}J(\theta-\mu m_t)\\
    \theta_{t+1}&=\theta_t-m_{t+1}
  \end{aligned}
  $$
+ [这篇文章](https://zhuanlan.zhihu.com/p/22810533)表明，添加了Nesterov项本质上是考虑了目标函数的二阶导信息
+ 在PyTorch中，设置SGD的`nesterov`为`True`即可使用该优化器
  ```python
  # in PyTorch
  torch.optim.SGD(params, lr=<required parameter>, momentum=0.9, dampening=0, weight_devay=0, nesterov=True)
  ```
+ 特点：<u>相较Momentum方法，NAG的优化速度更快</u>


## 自适应学习率算法

### AdaGrad
+ 定义$\delta$为全局学习率，$\epsilon$为极小常量和梯度加速变量$r$。
  $$
  \begin{aligned}
      g &\leftarrow \nabla_{theta} J(\theta)\\
      r &\leftarrow r+g^2\\
      \delta \theta \leftarrow \frac {\delta}{\sqrt{r+\epsilon}}\cdot g\\
      \theta \leftarrow \theta-\delta \theta\\
  \end{aligned}
  $$
  实际上$r$为之前所有时刻的梯度平方和$r=\sum_{i=1}^t g^2_i$，因此更新公式为
  $$\theta \leftarrow \theta -\frac \delta{\sqrt{\sum_{i=1}^t g_i^2 +\epsilon}}\nabla_\theta J(\theta)$$
+ 在pytorch中
    ```python
    # in PyTorch
    torch.optim.Adagrad(params, lr=0.01, lr_decay=0, weight_decay=0, initial_accumulator_value=0, eps=1e-10)
    ```
  + 很奇怪的是这里也加入了学习率的衰减因子
  + `initial_accumulator_value`为`r`的初值
+ 特点：<u>随着时刻的增加，梯度平方和也会增加，从而减小参数的变化量</u>
+ 缺点：<u>1. 仍然需要设置一个全局学习率；2. 分母的累积和会越来越大，导致训练提前结束。3. 在深度学习中，单调变化的学习率被证明会由于过于激进而过早停止学习。</u>

### RMSprop
+ 在AdaGrad的基础上，RMSprop修改了梯度加速变量的形式
  $$
  \begin{aligned}
      g &\leftarrow \nabla_\theta J(\theta)\\
      E[g^2]_t &\leftarrow \alpha E[g^2]_{t-1}+(1-\alpha)g^2_t\\
      \theta &\leftarrow \theta - \frac \delta{\sqrt{E[g^2]_t+\epsilon}}\nabla_\theta J(\theta)\\
  \end{aligned}
  $$
+ 在PyTorch中
  ```python
  torch.optim.RMSprop(params, lr=0.01, alpha=0.99, eps=1e-08, weight_decay=0, momentum=0, centered=False)
  ```
  + `alpha`: 对应公式中$E[g^2]$的平滑系数$\alpha$
  + `momentum`: RMSprop的更新公式中也可以使用动量优化
+ 特点：<u>仍然依赖于全局学习率$\delta$，适合处理非平稳目标的优化（例如季节性、周期性、RNN）。同时，在鞍点附近，由于累积项$E[g^2]$会下降，导致学习率增大，因此RMSprop能有效逃离目标函数的鞍点，在非凸的设置下性能更好。</u>
+ 缺点：<u>相应地，RMSprop在局部最优值附近会有抖动，因为此时学习率较大，</u>

### AdaDelta
+ 在RMSprop的基础上，移除了对于初始学习率的依赖
  $$
  \begin{aligned}
    E[g^2]_t &\leftarrow \rho E[g^2]_{t-1} + (1-\rho)g_t^2 \\
    \delta \theta &\leftarrow \frac {\sum_{i=1}^{t-1}\theta_t}{\sqrt{E[g^2]_t+\epsilon}}
  \end{aligned}
  $$
+ 在PyTorch中
  ```python
  # in PyTorch
  torch.optim.Adadelta(params, lr=1.0, rho=0.9, eps=1e-06, weight_decay=0)
  ```
  + `rho`: 累积项的滑动平均系数
+ 特点：<u>不需要手动设定初始的学习率。</u>

### Adam
+ Adam在自适应调整学习率算法的基础上添加了动量，并对动量和累积项进行了偏置修正
  $$
  \begin{aligned}
    m_t &= \beta_1 m_{t-1}+(1-\beta_1)g_t\\
    v_t &= \beta_2 v_{t-1}+(1-\beta_2)g_t^2\\
    \hat{m}_t &= \frac {m_t}{1-\beta_1^t}\\
    \hat{v}_t &=\frac {v_t}{1-\beta_2^t}\\
    \theta_{t+1} &= \theta_{t} - \frac {\eta}{\sqrt{\hat{v}_t}+\epsilon}\hat{m}_t
  \end{aligned}
  $$
  + 其中$m_t$和$v_t$分别是一阶动量项和二阶动量项，$\beta_1, \beta_2$通常分别取0.9和0.999。
+ 在PyTorch中
  ```python
  # in PyTorch
  torch.optim.Adam(params, lr=0.001, betas=(0.9, 0.999), eps=1e-08, weight_decay=0, amsgrad=False)
  ```
  + `betas`: 设定两个衰减因子$\beta_1, \beta_2$。
  + `amsgrad`: 设定是否要使用AMSGrad变种。
+ 特点：
  + <u>1. 结合了Adagrad善于处理系数梯度和RMSprop善于处理非平稳目标的优点（因为一阶动量项和二阶动量项分别位于分子和分母上）。</u>
  + <u>2. 能够为不同的参数分别计算不同的学习率。</u>
  + <u>适用于非凸优化问题、大数据集和高维空间。</u>

---
# 优化算法比较
[SanFanCSgo的一篇博客](https://blog.csdn.net/weixin_40170902/article/details/80092628)对上述算法的行为进行了详细的比较，在此截取部分结果呈现如下

> **实验1:** 
> ![](img/杂记1.gif)
> ① 下降速度：
> + 三个自适应学习优化器Adagrad、RMSProp与AdaDelta的下降速度明显比SGD要快，其中，Adagrad和RMSProp齐头并进，要比AdaDelta要快。
> + 两个动量优化器Momentum和NAG由于刚开始走了岔路，初期下降的慢；随着慢慢调整，下降速度越来越快，其中NAG到后期甚至超过了领先的Adagrad和RMSProp。
> 
> ② 下降轨迹：
> + SGD和三个自适应优化器轨迹大致相同。两个动量优化器初期走了“岔路”，后期也调整了过来。


> **实验2:**
> ![](img/杂记2.gif)
> 上图在一个存在鞍点的曲面，比较6中优化器的性能表现，从图中大致可以看出：
> + 三个自适应学习率优化器没有进入鞍点，其中，AdaDelta下降速度最快，Adagrad和RMSprop则齐头并进。
> + 两个动量优化器Momentum和NAG以及SGD都顺势进入了鞍点。但两个动量优化器在鞍点抖动了一会，就逃离了鞍点并迅速地下降，后来居上超过了Adagrad和RMSProp。
很遗憾，SGD进入了鞍点，却始终停留在了鞍点，没有再继续下降。

> **实验3**
> ![](img/杂记3.gif)
> ① 在运行速度方面
> + 两个动量优化器Momentum和NAG的速度最快，其次是三个自适应学习率优化器AdaGrad、AdaDelta以及RMSProp，最慢的则是SGD。
> 
> ② 在收敛轨迹方面
> + 两个动量优化器虽然运行速度很快，但是初中期走了很长的”岔路”。
三个自适应优化器中，Adagrad初期走了岔路，但后来迅速地调整了过来，但相比其他两个走的路最长；AdaDelta和RMSprop的运行轨迹差不多，但在快接近目标的时候，RMSProp会发生很明显的抖动。
> + SGD相比于其他优化器，走的路径是最短的，路子也比较正。