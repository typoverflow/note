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
    + 使用periodic checkpoints：定期将master节点的操作写入到日志当中

## MapReduce的性能
+ Locality：上文中已经提及，在此略过
+ Task Granularity
  + 任务粒度：每个计算节点实际上会处理多个Map进程或者Reduce进程
  + 例子
    + 使用2000台working machine来处理200000个Map任务和5000个Reduce任务
    + Map任务数目比Reduce任务数目要多是因为Reduce需要处理的数据已经经过Map的整合归并，相对更容易处理。
    ![](img/2020-12-11-14-37-58.png)
  + **Backup Task**
    + 任务完成的时间往往取决于最慢的任务
    + 当一个MapReduce操作快要结束时，master会对剩余的任务调度backup execution（实际上是等到识别出拖后腿的任务后再进行backup）。最终当primary execution或者backup execution中有任意一方完成后，使用它的结果作为MapReduce的结果。

---
## MapReduce论文阅读
+ 目的：设计一个新的抽象模型，只需要程序编写者表述想要执行的抽象运算，而无需关心计算、容错和数据分布、负载均衡等具体细节。意义在于通过简单的接口来实现自动的并行化和大规模并行化计算，同时提供了初级的容灾方案
+ 在Reduce环节，每个key与reduce worker的绑定是通过$hash(key)\  mod\  R$实现的
+ Map函数的输出将被缓存在缓存中，缓存中的key-value pair通过分区函数分成R个区域，之后**周期性的**写入到本地磁盘上，缓存在key、value pair在本地磁盘上的存储位置被回传给master，由master负责将这些存储位置在传送给Reduce worker
+ 完整的MapReduce框架实际上是由Map、Partition和Reduce来完成的，注意Partition的功能。Reduce实际上实现的是将键相同的值进行聚合处理，而partition是按照一定的模式将不同的key各自分发到不同的reduce中处理。默认情况下是使用Hash function进行key与reduce worker的绑定
  + 由于每一reduce worker都会各自将结果写入一个文件，因为partition可以实现将某些键的结果写入特定文件的作用。一个分区对应一个reduce worker，同时对应一个输出文件
  + 默认partitioner是hash partitioner

+ 存储与带宽使用
  + 数据会按照block的方式在多个计算节点的本地存储中存有拷贝。在MapReduce时会首先将任务分配到具有本地存储的那些节点上，然后在考虑邻近的节点
+ 顺序保证
  + 在给定的分区中，中间key/value pair的数据是按照key值的增量顺序处理的（可用于并行排序）
+ Combiner函数：在map的过程中先进行一次本地的归并处理