## L2 实验报告
+ Name: 高辰潇
+ STUID: 181220014
+ Email: derek.gaocx@gmail.com

### 框架
```
├── include
│   └── common.h
└── src
    ├── kmt.c        # kmt模块
    ├── lock_pmm.c   # L1中使用的锁定义及锁方法
    ├── os.c         # os模块
    ├── pmm.c        # pmm模块
    └── utils.c      # 其他函数及debug辅助函数
```

### 实现细节
#### 概述
+ os和kmt模块按照实验手册中给出的功能要求进行了正确实现
+ 通过在`kmt_init`中注册两个回调函数`kmt_context_save`和`kmt_schedule`来实现中断到来时的寄存器现场保存和线程调度

#### 关键结构体定义
+ **线程`task_t`**: 该结构体的定义在`common.h`文件中. 每个线程的大小为4KB, 其中头部存放关于线程的信息, 例如指向保存现场的指针`context`等
+ **cpu信息`cpu_t`**: 存放当前cpu上的中断嵌套层数`ncli`, 指向当前运行线程`cur`, 上一次运行的线程`last`, 和idle线程`cpu_idle`的指针等关键信息

#### 线程管理与调度
+ 线程由以全局变量`tlist`为链表头的循环链表组织起来. `kmt_create`在设置好新线程信息后, 会将新线程插入到该链表中；除此以外, 在每个cpu经历第一次中断保存寄存器现场时, 会申请创建一个新的线程, 在这个线程中保存线程, 并将其作为本cpu的idle线程. 
+ 由于绑定cpu和线程会导致starvation, 因此在提交版本中实现了cpu和线程的不绑定. 为了避免随之而来的stack race, 我仿照RCU实现了*调度缓冲区*机制. 即, 在某个cpu上正在运行的线程和上一次运行的线程都将被加入到缓冲区中, 在其他cpu发生中断时, 不允许调度处于任何cpu缓冲区中的线程. 在缓冲区机制下, 上课时提到的stack race可被避免.
  缓冲区机制由线程结构体中的`swap`实现. 当`swap`为1时, 表明该线程被交换到了缓冲区. 相应地, scheduler只需要管理好各线程的`swap`即可.
  因此, 时钟中断到来时完整的行为如下: 
```
保存现场 -> 伪随机一个数, 找到线程池中的对应线程 
        -> 若该线程可被调度, 则调度 
        -> 若不可调度, 找到他的下一个可被调度线程并调度 
        -> 若无可被调度线程, 检查当前cpu上一次调度的线程是否可被调度 
        -> 若也不行, 最后调度idle
```

### 印象深刻的Bug
+ **罄竹难书 ......**
+ 首先是由于不绑定而带来的stack race, 课上已经分析过, 略过~
+ 其次是自己的测试用例因为递归多次导致的线程stack overflow, 当初应该好好听jyy的话, 在栈区首尾设置canary
+ 再次是`push_cli`和`pop_cli`的问题, 一开始我的实现并不会保存`push_cli`之前的中断状态, 导致`pop_cli`后, 原本的cpu中断本应当是关闭的, 却失误打开了中断. 这个又会导致一系列奇怪的问题, 比如在`trap`返回后, qemu中断处理完全结束前, 系统又被中断. 最终通过检查qemu.log才排查出这个问题
+ 最后是一个很隐蔽的数据竞争: 一开始我并未将当前运行的线程加入到"调度缓冲区"(这是背景). 假设有两个cpu, cpu1上的线程A在P一个信号量时被阻塞, 状态设置为`TD_HANGUP`, 但是假设在其`_yield()`之前, cpu2上的线程执行了V操作并重新唤醒了线程A, 并且发生中断调度了线程A. 此时cpu1和cpu2都在运行线程A, 导致stack corruption. 
+ 个人感受, 这一部分的并发Bug之所以难调, 是因为它往往是并发程序的设计逻辑导致的错误. 使用gdb, qemu log等手段虽然能帮助快速定位到出错位置, 诊断原因, 但也只能告诉你表象的东西, 比如告诉你这里出现了一个stack corruption. 但是为什么会出现stack corruption还是需要通过分析log的方式去找出调度中出现的问题和异常, 这个在这次oslab中花费了我非常多的时间. 