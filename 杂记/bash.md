
[TOC]

# 写在前面：一些特殊的注意点
## Bash扩展
什么时候Bash会进行扩展？
有的Bash扩展属于路径名称的扩展，其中包括`* ? [] {} ~`，只有在路径解析时才会自动被扩展。在bash脚本中，只有在特定的语法环境下才能被扩展，比如数组变量的定义`array=( ... )`还有for循环的`in`后面等等。
关于变量扩展`$`和转义扩展`\`，视引号情况而定。

---

# Bash globbing
模块扩展（Bash Globbing）是Bash在解析命令时对命令进行扩展的一种方式，发生在Bash执行命令之前。因此，扩展的结果是由Bash负责的。

#### 波浪线扩展
+ `~`会被扩展为当前用户的主目录
+ `~user`会被扩展为`/home/<user>`，如果`<user>`不存在，这该扩展将失效
+ `~+`会被扩展为当前所在目录

#### `?`字符扩展
+ `?`可匹配**文件路径**中的单个字符，不包括空字符
  + `Data???`可匹配所有Data后跟随三个字符的文件名

#### `*`字符扩展
+ `*`可匹配文件路径中任意数量的任意字符
+ 如果需要匹配隐藏文件，这需要写成`.*`
  + 如果还需要同时排除`.`和`..`，这需要使用`.[!.]*`
+ 层级目录的匹配
  + `*/*.txt`可匹配所有一级子目录下的txt文件
  + `**/*.txt`可匹配所有目录及子目录下的txt文件

#### `[]`扩展
+ 类似正则表达式，方括号表示匹配候选字符中的一个
  + 匹配不在方括号内的字符使用`[^...]`和`[!...]`
  + 如果需要匹配`-`，则应放在所有候选字符的开头或结尾
+ `[start-end]`形式的扩展，略
+ 字符类扩展，使用特殊的控制字符匹配一类字符
  + `[[:class:]]`: 匹配任意英文字母和数字
  + `[[:alpha:]]`: 匹配任意英文字母
  + `[[:blank:]]`: 匹配空格和Tab
  + `[[:cntrl:]]`: 匹配ASCII码中0-31的不可打印字符
  + `[[:digit:]]`: 匹配任意数字
  + `[[:graph:]]`: 匹配`[[:alnum:]]`和标点符号
  + `[[:lower:]]`: 匹配任意小写字母
  + `[[:print:]]`: 匹配ASCII码32-127的可打印字符
  + `[[:punct:]]`: 匹配标点符号
  + `[[:space:]]`: 匹配空格，TAB，LF，VT，FF，CR
  + `[[:upper:]]`: 匹配大写字母
  + `[[:xdigit:]]`: 匹配16进制字符（A-F，a-f，0-9）
  + 使用`[^[:digit:]]`可匹配非数字开头，上同

#### `{}`扩展
+ `{}`扩展表示分别扩展成大括号内的所有值，注意需要使用逗号分隔开
  + `echo test{1,2,abc}.txt`得到`test1.txt test2.txt testabc.txt`
+ `{}`扩展可以嵌套，可以与其他扩展一并使用
+ **大括号扩展不是文件名扩展，因此它总是会先扩展的。并且当匹配的文件不存在时，大括号仍然会进行扩展。**
+ 可以使用`{start..end..step}`的形式进行范围扩展
  + `echo .{mp{3..4},m4{a,b,p,v}} -> .mp3 .mp4 .m4a .m4b .m4p .m4v`
  + `mkdir {2007..2009}-{01..12}`
  + 这种写法常见于bash语法下的for循环
    ```bash
    for i in {1..4}
    do
        echo $i
    done
    ```

#### 变量扩展
+ `$...`或者`${...}`会将内容视作变量，将其扩展为变量值
+ `${!string*}`会匹配所有以`string`开头的变量名

#### 命令扩展
+ `$(cmd)`会扩展为命令`cmd`执行的结果，所有输出都将作为返回值
+ 也可以使用反引号作为命令扩展，比如
    ```bash
    echo `date`
    ```

#### 算数扩展
+ `$(( ... ))`可以扩展为整数运算结果，比如
    ```bash
    echo $((2 + 2))
    4
    ```

#### 量词语法
+ 量词语法是用于扩展文件名的
+ `?(pattern-list)`：匹配零个或一个模式。
+ `*(pattern-list)`：匹配零个或多个模式。
+ `+(pattern-list)`：匹配一个或多个模式。
+ `@(pattern-list)`：只匹配一个模式。
+ `!(pattern-list)`：匹配给定模式以外的任何内容。
+ `pattern list`使用竖线进行分隔
  ```bash
  ls abc+(.php|.txt)

  abc.txt abc.php abc.txt.txt
  ```

#### shopt控制扩展参数
```bash
shopt -s [OptionName]  # 打开某个参数
shopt -u [OptionName]  # 关闭某个参数
shopt [OptionName]     # 查询某个参数是否打开
```
---
# Bash转义与引号
在Bash语言中，所有变量均被视作字符串，因此字符串相关的转义和引号很重要

## 转义
Bash中可使用反斜杠`\`对字符（比如`$ \`）进行转义。
除此以外，反斜杠还可用于表示一些不可打印字符，比如`\n \t \a`等。如果想要使用这些不可打印字符，需要在`echo`命令中使用`-e`参数

## 引号
+ 单引号保留字符的字面含义，Bash扩展、变量引用、算术运算和子命令在单引号中均失效
  + 在单引号情况下，如果单引号中还需要使用单引号，此时不能使用反斜杠，因为单引号中反斜杠会失效。正确的方法是`echo $'it\'s'`，即单引号前添加`$`，然后使用反斜杠转义
+ 双引号比单引号宽松，除了```$ ` \```之外的所有其他特殊字符都会失去特殊含义，保留为字面量。这意味着空格、换行之类的字符不会被Bash进行特殊处理。
  + 也正因此，双引号的一个特殊作用就是保持命令的原始输出格式
    ```bash
    $ echo `cal` 
    February 2021 Su Mo Tu We Th Fr Sa 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28

    $ echo "`cal`"
        February 2021   
    Su Mo Tu We Th Fr Sa
        1  2  3  4  5  6
    7  8  9 10 11 12 13
    14 15 16 17 18 19 20
    21 22 23 24 25 26 27
    28  
    ```

## Here文档
```bash
cat << _identifier_
  string
_identifier_
```
+ Here文档可将`_identifier_`标识符中包含的字符串作为标准输入传递给`cat`命令。默认情况下Here文档支持反斜杠转义和变量替换，但不支持通配符扩展。同时引号也将失去语法作用
+ 如果不希望发生变量替换，可将开始标记`_identifier_`包含在单引号中
```bash
cat << '_identifier_'
  string
_identifier_
```
+ 注意在Here文档中，标识符`identifier`可随意指定

---
# Bash变量
Bash变量分为环境变量和自定义变量，使用`env`可查看所有环境变量，而使用`set`可查看所有变量

## 创建变量
```bash
a=z                     # 变量 a 赋值为字符串 z
b="a string"            # 变量值包含空格，就必须放在引号里面
c="a string and $b"     # 变量值可以引用其他变量的值
d="\t\ta string\n"      # 变量值可以使用转义字符
e=$(ls -l foo.txt)      # 变量值可以是命令的执行结果
f=$((5 * 7))            # 变量值可以是数学运算的结果
```
## 读取变量
```bash
echo $var
echo ${var}
```
如果变量的值本身也是变量则可使用下面的语法读取最终值
```bash
echo ${!myvar}
```
+ **上述用于读取最终值的方法在zsh中无效**

## 删除变量
```bash
unset var_name
```

## 输出变量
+ 默认情况下用户创建的变量仅可用于当前SHELL，子SHELL只能继承父SHELL的环境变量。使用export命令可使用户定义的变量变为当前SHELL的环境变量

## 特殊变量
+ `$?`: 上一个命令的退出码
+ `$$`: 当前SHELL的进程ID
+ `$_`: 上一个命令的最后一个参数
+ `$!`: 最近一个后台执行的异步命令的进程ID

## 变量的默认值
```bash
${varname:-word} # 存在且非空则返回变量的值，否则返回word
${varname:=word} # 存在且非空则返回变量的值，否则将变量设置为word并返回word
${varname:+word} # 存在且非空则返回word，否则返回空值
${varname:?msg}  # 存在且非空则返回变量的值，否则打印msg并终止执行
```

## 特殊变量声明
+ 可以使用declare命令对变量类型和值作出限制
  + `-a`：声明数组变量。
  + `-f`：输出所有函数及其定义。
  + `-F`：输出所有函数名。
  + `-i`：声明整数变量。
  + `-l`：声明变量为小写字母。
  + `-p`：查看变量信息。
    ```bash
    $ foo=hello
    $ declare -p foo
    declare -- foo="hello"
    $ declare -p bar
    bar：未找到
    ```
  + `-r`：声明只读变量。
  + `-u`：声明变量为大写字母。
  + `-x`：该变量输出为环境变量。
+ 事实上declare既可用于声明变量，也可以用于将变量类型转换为指定的选项

## let命令
+ `let`命令声明变量时可以直接执行算术表达式。如果表达式中包含空格，则需要使用引号。另一方面，`let`命令可执行多个赋值表达式
```bash
$ let "v1 = 1" "v2 = v1++"
$ echo $v1,$v2
2,1
```

# Bash字符串操作
+ 获取字符串长度：`${#varname}`
  + 此处大括号是必须的，否则Bash会将`$#`结合，解释为脚本的参数个数，而将变量名理解为文本
+ 提取字串: `${varname:offset:length}`从位置offset（从0开始计数）开始获取长度为length的字串
  + 如果省略最后一个参数，则表示返回到字符串结尾
  + 如果offset为负值，则表示从结尾开始算起。此时必须要在负数前面空一格`${varname: -offset:length}`，防止与`${variable:-word}`的语法混淆

## 字符串搜索与替换

---

# Bash数值运算

## 基本数字运算与位运算
+ 使用`$(( expr ))`可对表达式expr进行整数运算，支持的运算有`+ - * / ++ -- ** << >> & | ~ ^`
+ 当expr中包含字符串时，Bash会将其作为变量名进行解释。如果存在对应的变量且为数字，则使用该数字带入运算；如果变量的值仍为字符串，则进一步查找同名变量；如果变量不存在则代入0
  ```bash
  foo="Hello"
  Hello=3
  echo $((Hello+1))
  ```
+ 多个计算表达式可使用`,`隔开，会依次按照顺序执行每一个表达式

## 进制
Bash默认使用十进制，但也可显式指定数的进制
+ `<number>`: 默认情况，十进制
+ `0<number>`: 八进制
+ `0x<number>`: 十六进制
+ `base#<number>`: base进制

Bash数学运算的最终返回结果默认为十进制。

## 基本逻辑运算
+ `$(( expr ))`还支持下述逻辑运算: `< > <= >= == != &&, || ! expr1?expr2:expr3`
+ 如果表达式为真则返回结果为1，否则为0

## 赋值运算
+ 与c语言一样，`$(( ))`中也支持赋值运算，比如`= += -= *= /=`等，返回值是等号右边的值

## expr命令与let命令
expr可以进行算术运算
```bash
expr 3 + 2
foo=3
expr $foo + 3
```
或者使用let命令，将算数命令的结果赋予变量
```bash
let x=2+3
```

---
---
# Bash脚本
## 基本知识
### Shebang行
Shebang行：告诉操作系统应该如何执行该文件
```bash
#! /usr/bin
#! /usr/bin/python3
```
以防万一，可结合`env`命令得到可移植性更强的程序
```bash
#! /usr/bin/env bash
```
上述方法可结合`env`命令理解
```bash
env: Set each NAME to VALUE in the environment and run COMMAND.
```
### 脚本参数
使用`$1 $2 ... $9 ${10} ...`可依次读取脚本执行时的参数，`$0`默认为脚本名称

`$@`返回包括全部参数的列表，可以使用for循环依次读取所有参数
```bash
#! /bin/bash
for i in $@; do
  echo $i
done
```

### 参数解析：`getopts`
在Bash脚本内部可以使用`getopts`命令来解析脚本的带有前置连词线`-`的参数。
```bash
getopts optstring varname
```
假设一个脚本可以有三个配置项参数`-l -h -a`，其中只有`-a`可以带有参数值，`-l -h`都是开关参数。那么`getopts`的第一个参数便为`lha:`。以下是一个使用`getopts`对脚本参数进行解析的示例

```bash
while getopts 'lha:' OPTION; do
  case "$OPTION" in 
    l)
      echo "get -l"
      ;;
    h)
      echo "get -h"
      ;;
    a)
      avalue="$OPTARG"
      echo "get -a and set avalue"
      ;;
    ?)
      echo "script usage: $(basename $0) [-l] [-h] [-a somevalue]" >&2
      ;;
  esac
done
shift "$(( $OPTIND - 1 ))"
```
在以上程序中，使用while循环处理参数，每次配置项参数被存储在`OPTION`中，而参数内容位于`OPTARG`。`OPTIND`的初始值为1，每次成功处理后会向右位移本次处理的参数个数，因此根据这个可以得知前面有多少个参数是“配置项参数”，并使用shift函数来确保后面的$1均为主参数。

有的时候在解析变量作为另一个命令的主参数时，如果变量的值以`-`开头，则很可能会被误当作命令的配置项参数。此时可以使用`--`手动分隔配置项参数和主参数

```bash
$ myPath="-l"
$ ls -- $myPath
ls: 无法访问'-l': 没有那个文件或目录
```

## 输入流：read命令
read命令从标准输入中读取数据存入一个变量
```bash
read [-options] [variable]

read text  # 读取输入到text中
read A B   # 读取输入，根据LFS分割为两个值，分别存入A和B
read       # 未指定存取变量时，默认存入环境变量REPLY
```

read还可以读取文件
```bash
filename="/tmp/testfile"
while read myline
do
  echo "$myline"
done < $filename
```

### read参数
+ `-t timeout`: 设置超时秒数。使用环境变量`TMOUT`也可起到相同作用
  ```bash
  read -t 3 response

  TMOUT=5
  read -t 5 response
  ```
+ `-p prompt`: 指定用户输入的提示信息
+ `-a`: 把用户输入赋值给一个数组。如果不指定该参数，输入的内容会以字面量形式存入变量。
  ```bash
  $ read -a people
  alice duchess dodo
  $ echo ${people[2]}
  dodo
  ```
+ `-n number`: 指定最多读取的字符数量
+ `-e`: 允许用户在输入的时候使用自动补全
+ `-d delimiter`: 定义字符串`delimiter`的第一个字符作为用户输入的结束，而不是换行符
+ `-s`: 使用户输入不显示在屏幕上
+ `-r`: raw模式，不对用户输入进行转义
+ `-u fd`: 使用文件描述符fd作为输入

### IFS
read读取的值默认以空格进行分隔，可通过自定义环境变量IFS(Internal Field Seperator)修改
```bash
#!/bin/bash
# read-ifs: read fields from a file

FILE=/etc/passwd

read -p "Enter a username > " user_name
file_info="$(grep "^$user_name:" $FILE)"

if [ -n "$file_info" ]; then
  IFS=":" read user pw uid gid name home shell <<< "$file_info"
  echo "User = '$user'"
  echo "UID = '$uid'"
  echo "GID = '$gid'"
  echo "Full Name = '$name'"
  echo "Home Dir. = '$home'"
  echo "Shell = '$shell'"
else
  echo "No such user '$user_name'" >&2
  exit 1
fi
```

## 流程控制

### if结构
```bash
if commands; then
  commands
[elif commands; then
  commands ...]
[else 
  commands]
fi
```
> 注意此处分号的使用。分号是为了区分不同代码块的内容，当且仅当不同代码块被放在同一行中时使用。有趣的是此处then和elif后不需要使用分号，应当是流程控制语句的specifications。

`if`语句后可以跟随任意数量的命令，此时所有命令都会执行，但是判断真伪只取决于最后一个命令。

注意`if`后必须跟随命令，而不是值。

```bash
if false; true; then echo 'hello world'; fi
```

##### test命令
test命令常常用于if条件判断后的指令，有三种基本形式
```bash
test expression
[ expression ]
[[ expression ]]
```
test需要使用具体的配置项参数来指明应当进行何种条件判断，具体可参考manual。

当条件成立时test返回0，否则返回1。if判断命令返回0时表示判断成立，否则表示不成立。

> 一点注意点：`[ -e ]`会判断为真，`[ -e "" ]`会判断为伪。因此进行文件存在性判断时最好`[ -e "$FILE" ]`
> 为了防止出现意外，一般情况下都需要将待判断的表达式防止在双引号内。

`[[ ]]`为正则判断，其形式如下，即判断字符串`string1`是否满足正则表达式`regex`的形式
```bash
[[ string1 =~ regex ]]
```

使用`&& || !`等符号可对`test`结果进行逻辑运算
```bash
#! /bin/bash
MIN_VAL=1
MAX_VAL=100
INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
  if [[ $INT -ge $MIN_VAL && $INT -le $MAX_VAL ]]; then
    echo "$INT is within $MIN_VAL to $MAX_VAL."
  else
    echo "$INT is out of range."
  fi
else
  echo "INT is not an integer." >&2
  exit 1
fi
```

##### 算术表达式
Bash还可以使用算术表达式`(( ))`作为if条件进行判断
```bash
if ((3 > 2)); then
  echo "true"
fi
```
与`test`不同的是，使用算术表达式时，只有运算结果非0时才会判断为真。

##### 普通命令
如果使用普通的命令，那么if的条件判断行为和使用`test`一致。
```bash
#! /usr/bin/env bash
# 在文件中匹配单词

filename=$1
word1=$2
word2=$3
if grep $word1 $filename && grep $word2 $filename; then
	echo "Both $word1 and $word2 are in $filename"
else echo "Bye."
fi
```

### case结构
case结构用于多值判断，语法如下
```bash
case expression in
  pattern1 )
    commands ;;
  pattern2 )
    commands ;;
  ...
esac
```
case的匹配模式可以使用各种通配符，比如
+ `a)`：匹配`a`
+ `a|b)`：匹配`a`或`b`
+ `[[:alpha:]]`：匹配单个字母
+ `???)`：匹配三个字符的字符串
+ `*.txt)`：匹配`.txt`结尾
+ `*)`：匹配任意输入
一般情况下，可以设置模式为`*`的case分支来作为default分支

如果想匹配多个分支，可以使用`;;&`终止每个条件块。

### while结构
```bash
while condition; do
  commands
done
```
和`if`结构一样，condition部分可以使用`test`、算术表达式和普通命令；并且`condition`处可以有多个命令，以最后一个命令的判断结果作为是否继续执行while命令的标准。

### until结构
与while结构相反，只要判断满足条件，就跳出循环
```bash
util conditionl do
  commands
done
```
譬如一个通用的做法是轮询，直到某个命令执行成功前，不断重复尝试
```bash
util cp $1 $2; do
  echo "Attempt to copy failed, retrying..."
  sleep 5
done
```

### for结构
```bash
for variable in list
do
  commands
done
```
list的可选形式包括
+ 通配符`*.png`，这样会让`i`便利所有以`.png`结尾的文件
+ 数组变量。只要变量不以`""`包裹，那么bash在解释时会默认它为数组变量
+ `"var1" "var2" "var3"`等形式

### break continue结构
bash提供了两个内置命令`break`和`continue`用于流程控制。

### select结构
Bash会对select依次进行下面的处理。
+ select生成一个菜单，内容是列表list的每一项，并且每一项前面还有一个数字编号。
+ Bash提示用户选择一项，输入它的编号。
+ 用户输入以后，Bash 会将该项的内容存在变量name，该项的编号存入环境变量REPLY。如果用户没有输入，就按回车键，Bash 会重新输出菜单，让用户选择。
+ 执行命令体commands。
+ 执行结束后，回到第一步，重复这个过程。

```bash
#!/bin/bash

echo "Which Operating System do you like?"

select os in Ubuntu LinuxMint Windows8 Windows10 WindowsXP
do
  case $os in
    "Ubuntu"|"LinuxMint")
      echo "I also use $os."
    ;;
    "Windows8" | "Windows10" | "WindowsXP")
      echo "Why don't you try Linux?"
    ;;
    *)
      echo "Invalid entry."
      break
    ;;
  esac
done
```

> 在所有的流程控制中，除了`if`结构使用`then`语句，其余的流程控制都需要结合`do...done`语法。

## 函数
函数是可供重复使用的代码片段，其与脚本的区别在于，函数在当前Shell中执行。从优先级上来讲，当别名、函数、脚本同名时，执行顺序为`别名 -> 函数 -> 脚本`。

函数的基本语法为
```bash
fn() {
  # codes
}

function fn() {
  # codes
}
```

+ 使用`unset -f functionname`可以删除一个函数。
+ `declare -f`可查看当前SHELL所有定义的函数。`declare -f functionname`可以查看单个函数的定义。`declare -F`可以查看所有定义的函数名（不含函数体）。

### 函数参数
在函数中可以使用`$1 $2 ... $@`获取函数的参数/参数列表，`$#`获取参数总数，`$*`获取函数的全部参数，参数使用自定义的`IFS`变量分隔。**注意即使是在函数内，`$0`仍然是脚本名称。**

下面是一个带时间输出日志的脚本函数。
```bash
function log_msg {
  echo "[`date '+ %F %T'` ]: $@"
}

$ log_msg "This is a demo msg"
[ 2021-03-04 16:30:42 ]: This is a demo msg
```

### 函数返回值
使用return语句可将返回值返回给调用者。如果没有return语句，则默认返回值为函数最后一条语句的输出。

### 函数内变量
+ 函数内变量默认是全局变量，如果需要非全局变量，则需要使用关键字`local`来声明

---

# Bash数组
## 创建数组
  ```bash
  # 使用赋值语法创建三个成员的数组
  array[0]=val
  array[1]=val
  array[2]=val

  # 也可以使用一次性赋值的方式
  array=(value1 value2 value3)

  # 上面的方式中，可以在每个值前指定位置
  array=(value1 [2]=value2 value3)

  # 括号语法中还可以使用通配符等路径扩展
  array=(*.c ../*.c)

  # 或者使用read和declare等语法创建新数组
  declare -a array
  read -a array
  ```

## 元素获取
在元素获取这一部分，需要着重关注的是`$array[@]  $array[*]  "$array[@]"  "$array[*]"`的不同之处。

在Bash语法中，`${a}`和`"${a}"`不同之处在于，前一种方式会将变量`a`的值按照`IFS`进行分割，并对分割出的每个部分进行`filename generation`（split+glob operator）。而使用引号后，bash将不会对字符串进行分割。
```bash
a="name1 name2"
for i in $a; do
  echo "$i"
done

# 输出为 name1 \n name2

for i in "$a"; do
  echo "$i"
done

# 输出为 name1 name2
```

至于`$*`与`$@`，当它们不带引号时会被扩展为
```bash
${array[0]}\ ${array[1]}\ ...\ ${array[n]}
```
。这里的`\ `表示空格仅用于分隔变量。带上引号后，他们的扩展行为不同
+ `"$*"`会被扩展为`"${array[0]}${IFS}${array[1]}${IFS} ... ${IFS}${array[n]}"`，即使用`$IFS`连接各数组元素后的字符串，为单一变量
+ `"$@"`会被扩展为`"${array[0]}"\ "${array[1]}"\ ...\ "${array[n]}"`，即数组中各个变量会以字面量解释，扩展结果为这些字面量形成的数组。

根据这些规则可对`$array[@]  $array[*]  "$array[@]"  "$array[*]"`结果各不相同的现象作出解释。
```bash
array=("a" "b" "c d")
IFS=" "
```
+ 使用`$*`
  ```bash
  for i in $*; do
    echo ${i}
  done
  ```
  结果为
  ```bash
  a
  b
  c
  d
  ```
  因为不带引号时`$*`扩展为```${array[0]}\ ${array[1]}\ ${array[2]}```，是一个数组，由于每一个元素都不带引号，因此`array[2]`会被split and glob，被分割成`c`和`d`
+ 使用`$@`结果为
  ```bash
  a
  b
  c
  d
  ```
  上文提到不用引号时`$*`和`$@`行为一致，因此结果一致。
+ 使用`"$*"`，结果为
  ```bash
  a b c d
  ```
  加上引号时，`"$*"`扩展为单一的字面量，因此结果为这个。
+ 使用`"$@"`，结果为
  ```bash
  a
  b
  c d
  ```
  加上引号时`"$@"`的扩展结果为字面量的数组，因此最后一个`"${array[2]"}`不会被split and glob。


读取数组长度使用`${#array[@]}`和`${#array[*]}`均可。

## 删除成员
```bash
unset arrayname  # 删除数组
unset arrayname[index]  # 删除数组中坐标为index的成员
arrayname[index]=""  # “隐藏”坐标为index的成员，并没有删除，但是echo时看不到了
```

---
# set命令和shopt命令
+ 一般情况下Bash在执行脚本时会创建子SHELL，`set`命令可以设定子SHELL环境的各种参数。
  + `set -u | set -o nounset`: SHELL在遇到不存在的变量时会报错，而不是解释为空字符串
  + `set -x | set -o xtrace`: Bash在执行一行命令前，会先输出命令的内容。`set +x`可以关闭命令输出。
  + `set -e | set -o errexit`: 脚本只要遇到错误（返回值非0）就会停止运行
  + `set -n | set -o noexec`: 不运行命令，只检查语法是否正确
  + `set -f | set -o noglob`: 不对通配符进行文件名扩展
+ `shopt`命令也能用来调整SHELL的参数，和`set`相似。`set`是从Ksh继承的，而`shopt`时Bash特有的命令。
  + `shopt -s`: 打开某个参数
  + `shopt -u`: 关闭某个参数
  + `shopt -q`: 查询某个参数是否打开，查询结果使用指令执行的返回值表示。`$?`为0表示该参数打开。
  ```bash
  if !(shopt -q globstar); then
  ...
  fi
  ```

---
# DEBUG环境变量
+ `LINENO`: 返回当前语句在脚本中的行号
+ `FUNCNAME`: 返回数组，内容是当前的函数调用堆栈，0号成员为当前调用的函数，1号成员为调用当前函数的函数，以此类推
+ `BASH_SOURCE`: 返回数组，内容是当前的脚本调用堆栈


