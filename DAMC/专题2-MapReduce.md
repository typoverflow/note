# MapReduce的概念、原理和应用

## 概念
+ Map Step
  + Master node takes the input, partitions it up into smaller sub-problems, and distributes it into worker nodes. A worker may do this again in turn, and thus resulting in a multi-level tree structure. The worker processes the smaller problems, and passes the answer back to the master node.
+ Reduce Step
  + The master node takes the answers of all the sub-problems and combines them in some way to get the final output.

## 整体流程
![](img/2020-12-04-15-08-33.png)
+ Map和Reduce为需要用户完成的部分
![](img/2020-12-04-15-13-20.png)
+ **Step1**：MapReduce库会首先将输入分割成16 MB到64 MB大小的块，然后会在节点簇上启动程序的多个副本
+ **Step2**：在启动的程序副本中，有一个是master，其他均为被分配了工作负载的workers。工作负载分为两种---Map和Reduce
+ **Step3**：被分配到Map工作负载的worker从相应的input split中读取内容，处理得到key-value键值对并存储在buffer当中
+ **Step4**：存储在buffer中的key-value键值对将通过“local write”的形式写入local disk，并由partitioning function分割成R个区域。这些buffered key-value pairs在local disk上的位置将被传递给master节点，由master节点将key-value pair的位置发送给reduce节点
+ **Step5**：reduce worker接收到master发送的数据地址后，使用“remote read”方式读取出key-value pair数据并对相同的key进行group处理
+ **Step6**：根据用户定义的reduce function，对key-value pair进行处理，得到输出

## MapReduce的函数定义
+ Distributed Grep
  + **Map**: A line if it matches a supplied pattern
  + **Reduce**: An identity function that just copies the supplied intermediate data to the output
+ Count of URL Access
  + **Map**: Process logs of web page requests and output <URL, 1>
  + **Reduce**: Add together all values for the same URL and emits <URL, total> pair
+ Reverse Web-Link Graph
  + **Map**: Output <target, source> pairs for each link to a target URL found in a page named source
  + **Reduce**: Concate the list of all source URLs associated with a given target URL and emits the pair <target, list(sources)>

## MapReduce并发度分析

## MapReduce的失效处理
+ MapReduce的并行方式同时也提供了从错误或者失效状况中恢复出来的能力
  + Worker Failure：当某个计算节点或者中间元组存储节点失效时，工作服载可以被master分配到其他单元上
    + locality：对于一个数据的split，它往往被分配到多个计算节点中（比如worker1和worker2）（此时worker1和worker2在 物理意义上也往往是相近的）。当worker1失效时，master节点将会考虑上述局部性信息，调度worker1附近的worker2进行计算
  + Master Failure：对于MapReduce这种架构来说，Master节点失效是比较严重的问题
    + 使用periodic checkpoinits：定期将master节点的操作写入到日志当中

## MapReduce的性能
+ Locality：上文中已经提及，在此略过
+ Task Granularity
  + 任务粒度：每个计算节点实际上会处理多个Map进程或者Reduce进程
  + 例子
    + 使用2000台working machine来处理200000个Map任务和5000个Reduce任务
    + Map任务数目比Reduce任务数目要多是因为Reduce需要处理的数据已经经过Map的整合归并，相对更容易处理。
    ![](img/2020-12-11-14-37-58.png)
  + Backup Task
    + 任务完成的时间往往取决于最慢的任务
    + 当一个MapReduce操作快要结束时，master会对剩余的任务调度backup execution（实际上是等到识别出拖后腿的任务后再进行backup）。最终当primary execution或者backup execution中有任意一方完成后，使用它的结果作为MapReduce的结果。

