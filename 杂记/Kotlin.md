# Kotlin

## 函数
+ 函数作用域
  + 函数可以在顶层声明，不需要使用一个类来保存一个函数
  + 局部函数：可以在一个函数内部声明一个函数，局部函数可以访问闭包中的变量
    ```kotlin
    fun dfs(graph: Graph) {
        val visited = HashSet<Vertex>()
        fun dfs(current: Vertex) {
            if (!visited.add(current)) return
            for (v in current.neighbors)
                dfs(v)
        }

        dfs(graph.vertices[0])
    }
    ```
    + 在函数内部重新定义了局部函数dfs，从而无需给出一个启动函数！python实际上也支持这种重命名闭包的形式。
  + 成员函数：在类内部定义的函数
  + 泛型函数：在函数名前使用尖括号指定
    ```kotlin
    fun <T> singletonList(item:T): List<T> {
        // ...
    }
    ```
+ 函数定义
  + 函数的参数列表和返回值
    ```kotlin
    fun sum(a: Int, b: Array<Byte>, len:Int=b.size): Int {
        // 函数体
    }
    ```
    + Unit表示“void”类型的返回值
    + 可以通过默认参数减少重载量
  + 将表达式作为函数体
    ```kotlin
    fun sum(a: Int, b:Int) Int = a+b
    ```
    + 如果返回值类型可以自动推断，此时也可以省略返回值类型
  + 可变数量参数，使用varargs进行修饰
    ```kotlin
    fun <T> asList(vararg ts:T): List<T> {
        val result = ArrayList<T>()
        for (t in ts)
            result.add(t)
        return result
    }
    ```
    + 类型T的vararg参数的可见方式是作为T数组，即ts具有类型`Array <out T`
  + 中缀函数，使用infix关键字修饰，必须是成员函数或扩展函数，必须只有一个参数且不能为可变数量参数，不能有默认值
    ```kotlin
    infix fun Int.shl(x:Int): Int {
        //...
    }

    1 shl 2
    //等同于
    1.shl(2)
    ```
+ 函数调用
  + 传统方法
  ```kotlin
  val result = double(2)
  ```
  + 成员函数
  ```kotlin
  Stream.read()
  ```

## 变量
+ 只读局部变量：使用关键字`val`，只能赋值一次
+ 可重新赋值的变量：使用关键字`var`
+ 顶层变量：类似全局变量

## 字符串模板
+ 在字符串中可以使用`${}`或`$name`来将命令替换为命令输出

## 空值与null检测
+ 使用`Typename?`来标识该引用可为空值

## 类型检测与自动类型转换
+ 在is操作判断引用类型后，将会触发自动类型转换
```kotlin
fun getStringLength(obj: Any): Int? {
    // `obj` 在 `&&` 右边自动转换成 `String` 类型
    if (obj is String && obj.length > 0) {
      return obj.length
    }

    return null
}
```

## 流程控制与其他关键词
+ for循环
    ```kotlin
    val items = listOf("apple", "banana", "kiwifruit")
    for (item in items) {
        println(item)
    }
    ```
    或者
    ```kotlin
    val items = listOf("apple", "banana", "kiwifruit")
    for (index in items.indices) {
        println("item at $index is ${items[index]}")
    }
    ```
+ when表达式
    ```kotlin
    fun describe(obj: Any): String =
        when (obj) {
            1          -> "One"
            "Hello"    -> "Greeting"
            is Long    -> "Long"
            !is String -> "Not a string"
            else       -> "Unknown"
        }
    ```
    + 相当于多层的if-else，比一般的switch case功能强大得多
+ 使用区间和判断操作in
    ```kotlin
    val list = listOf("a", "b", "c")

    if (-1 !in 0..list.lastIndex) {
        println("-1 is out of range")
    }
    if (list.size !in list.indices) {
        println("list size is out of valid list indices range, too")
    }
    ```
  + 区间也可以视作迭代
    ```kotlin
    for (x in 1..10 step 2) {
        print(x)
    }
    for (x in 9 downTo 0 step 3) {
        print(x)
    }
    ```
+ 使用lambda表达式
  ```kotlin
    val fruits = listOf("banana", "avocado", "apple", "kiwifruit")
    fruits
    .filter { it.startsWith("a") }
    .sortedBy { it }
    .map { it.toUpperCase() }
    .forEach { println(it) }
  ```

## lambda表达式
#### 高阶函数：将函数用作参数或者返回值
```kotlin
fun <T, R> Collection<T>.fold(
    initial: R, 
    combine: (acc: R, nextElement: T) -> R
): R {
    var accumulator: R = initial
    for (element: T in this) {
        accumulator = combine(accumulator, element)
    }
    return accumulator
}
```

#### lambda表达式实例
+ 将花括号内的语句作为代码块
```kotlin
val items = listOf(1, 2, 3, 4, 5)

// Lambdas 表达式是花括号括起来的代码块。
items.fold(0, { 
    // 如果一个 lambda 表达式有参数，前面是参数，后跟“->”
    acc: Int, i: Int -> 
    print("acc = $acc, i = $i, ") 
    val result = acc + i
    println("result = $result")
    // lambda 表达式中的最后一个表达式是返回值：
    result
})

// lambda 表达式的参数类型是可选的，如果能够推断出来的话：
val joinedToString = items.fold("Elements:", { acc, i -> acc + " " + i })

// 函数引用也可以用于高阶函数调用：
val product = items.fold(1, Int::times)
``