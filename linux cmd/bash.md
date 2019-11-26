# linux bash commands
## section 1
+ ||, &&, ;
  + command1; command2; command3会顺次执行三条命令
  + command1 && command2 会首先执行第一条命令，如果执行失败，将不会执行command2
  + command1 || command2 会首先执行第一条命令，当且仅当command1执行失败时才会执行command2
+ ?
  + 用于存储上一次命令的返回值
  + 使用echo $?可查看上一次命令的输出结果
## 管道命令
+ | 管道命令
  + 管道是一种通信机制，通常用于
  + 表示将前面一个命令的输出作为后一个命令的stdin
+ 选取命令cut
```
cut -d '分割字符' -f field
cut -c 字符范围
【参数说明】
-d : 后面接分隔字符,通常与 -f 一起使用
-f : 根据-d 将信息分隔成数段，-f 后接数字 表示取出第几段
-c : 以字符为单位取出固定字符区间的信息
```

