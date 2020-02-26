# MiniLab1: pstree命令
+ 本次实验要求是实现Linux系统工具pstree命令，并实现其中的`-n`, `-p`, `-V`三个选项

## 代码细节
+ 代码细节请查看本目录下`README.md`中指向的`os-workbench`仓库。
+ 由于这次的实验只有两个easy test和一个hard test，所以测试很顺利地就通过了，没有额外写对异常进行捕获处理的模块。

## 实验中遇到的bug
实验中遇到了一个bug，本质上是我对字符数组和指针不够熟悉导致的。

实验一开始我对`procInfo`结构体的定义如下
```c
struct procInfo {
    int pid; 
    char* name;
    struct procInfo* next;
    struct procInfo* child;
};
```
但是后来在扫描文件输入进程名时却扫描失败，要么是报段错误，要么是扫描到null
```c
sscanf(line, "Name:\t%s", procInfo[i].name)
```
这是因为，系统在初始化`procInfo`数组时并未为每个结构体中的指针分配空间。当这个指针被传给`sscanf`作为存放字符串的变量时，会因越界而出现段错误。因此应当添加额外的`malloc`步骤。

后来我采用的是直接在结构体内申请字符数组的方法
```c
struct procInfo {
    int pid;
    char name[64]; 
    struct procInfo* next; 
    struct procInfo* child; 
}
```
这样每个结构体中内联了一块内存地址用于存放字符串，bug解除。

**由此总结以下c语言中有关字符串和字符数组的知识**
c语言中字符串是常量，凡是在代码中明文写出的字符串都被存放在只读数据区，地址恒定，不可修改
非明文写出的字符串（比如字符数组等）都在栈区或堆区临时生成，可被修改，随栈帧变化而变化。