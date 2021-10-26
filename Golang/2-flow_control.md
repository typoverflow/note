# Golang流程控制

## 循环结构
```go
sum := 0
for i:=0; sum < 30; i++; {
    sum += i
}
```
初始化语句和后置语句是可选的，如果不添加初始化语句和后置语句，可以省略分号
```go
for sum < 30 {
    sum += 1
}
```
为了实现无限循环，甚至可以省略条件判断语句
```go
for {
    ...
}
```

## 条件分支结构
```go
if some_cond {
    ...
} else  {
    ...
}
```
在条件语句之前可以添加一个简单语句用于赋值
```go
if v := some_expr; v<lim {
    ...
}
```

同时还有switch结构
```go
switch some_var {
    case "Darwin":
        do_something
    case "Linux":
        do_something
    default: 
        do_something
}
```
注意，**在Go中执行某个switch分支后会自动break；以及some_var之前依然可以执行一个简单的赋值语句。**

没有条件的switch和switch true一样，可以将一长串if-then-else写的更清晰
```go
switch {
    case t.Hour() < 12:
        fmt.Println("Good morning!")
    case t.Hour() < 17:
        fmt.Println("Good afternoon!")
    default:
        fmt.Println("Good evening!")
}
```

## 其他控制语句
+ `defer`可以将语句留到函数return之后再执行 ，常常用于资源的回收
+ `panic(some_value)`会使当前函数栈进入panicking状态（但是会执行defer），同时向上递归，使函数栈的中的函数逐级进入panicking状态。如果没有recover之类的处理，最终会exception
+ `recover`: 只有出现在defer中才是有效的。会将当前goroutine从panicking中恢复，返回panic时传入的值。某种程度上这就做到了异常值的向上传递。

关于defer、panic和recover参考[这篇文章](https://blog.go-zh.org/defer-panic-and-recover)