# Golang Basics

## Go的基本类型
Golang中的类型有
```go
bool

string

int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr

byte // uint8 的别名

rune // int32 的别名
    // 表示一个 Unicode 码点

float32 float64

complex64 complex128
```
打印一个变量的类型可以使用`%T`格式控制符，打印变量的值可以使用`%v`格式控制字符。
```go
fmt.Println("Type is %T, Value is %v\n", some_var, some_var)
```

## Go的类型声明与函数
和C不同，Go使用后置类型名的方式规定变量的类型。参考[这个链接](https://blog.go-zh.org/gos-declaration-syntax)。
+ 连续两个或多个函数的命名形参类型相同/命名返回值类型相同时，可以只保留最后一个类型
  ```go
  func swap(x, y int) (z, w int) {
    z = y
    w = x
    return
  }
  ```
+ 当返回值被命名时，使用空的`return``语句可以自动返回返回值的名字对应的变量。可以认为，在函数的顶部会首先使用返回值的名字定义变量，最后返回这些变量。

## 变量
+ var语句用于声明一个函数列表
  ```go
  var c, python, java bool
  ```
+ 变量声明可以包含初始值，如果已经有初始值，可以省略类型，将从初始值中获得类型
  ```go
  var i, j int = 2, 3
  var c, python, java = false, 1, "no"
  ```
  更复杂一点的声明句式，可以使用var后面接括号实现
  ```go
  var (
	ToBo bool	= false
	MaxInt uint64	= 1<<64-1
	z complex128	= cmqlx.Sqrt(-5+12i)
  )
  ```
+ **短变量声明**：函数内的语句可以使用`:=`代替var进行声明。但是在函数外不可以这么做。
+ 没有明确赋予初值的变量将被赋予**零值**
  + 数值类型为 0，
  + 布尔类型为 false，
  + 字符串为 ""（空字符串）。

## Go类型转换与推导
Go不会进行隐式类型转换，需要进行显式转换
```go
var1 := []uint(some_var)
var2 := (*uint)(some_var)
var3 := float64(some_var)
```
在声明一个变量而不指定其类型时（即使用不带类型的 := 语法或 var = 表达式语法），变量的类型由右值推导得出。如果右值是一个声明了类型的变量，那么新变量的类型将保持一致。

## 常量的声明
常量使用`const`声明，可以是字符、字符串、布尔值或数值
```go
const Truth = True
```

