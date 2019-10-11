# java笔记

## 修饰符

### 访问控制修饰符
+ defualt
  + 在同一包内可见，不使用任何修饰符。使用对象：类、接口、变量、方法。
+ private
  + 在同一类内可见。使用对象：变量、方法。 注意：不能修饰类（外部类），也不能用于修饰接口
+ public
  + 对所有类可见。使用对象：类、接口、变量、方法
+ protected
  + 对同一包内的类和所有子类可见。使用对象：变量、方法。 注意：不能修饰类（外部类），也不能用于修饰接口。

### 非访问控制修饰符
+ static
  + 修饰变量形成静态变量
  + 修饰方法形成静态方法，静态方法只能使用静态变量。
  + 对静态方法、静态变量的访问可以使用Classname.StaticVariable/.StaticMethod
+ final
  + 修饰变量形成常量
  + 用final修饰的类方法可以被子类继承，但不能被子类重写。
  + 用final修饰的类无法被继承。
  ```java
  public final class Test{
      //...
  }
  ```
+ abstract
  + 用于声明抽象类。抽象类无法被实例化，仅用于后续子类的扩充。
  ```java
  public abstract class Test{
      //...
  }
  ```
+ synchronized
  + synchronized关键字声明的方法、变量同一时间只能被一个线程所访问。
  + 实际上可以认为被synchronized修饰的非静态变量额外维护了一个对象锁，修饰的静态对象额外维护了一个类锁。
+ volatile
  + volatile 修饰的成员变量在每次被线程访问时，都强制从共享内存中重新读取该成员变量的值。而且，当成员变量发生变化时，会强制线程将变化值回写到共享内存。这样在任何时刻，两个不同的线程总是看到某个成员变量的同一个值。
  ```java
  public class MyRunnable implements Runnable{
        private volatile boolean active;
        public void run(){
            active = true;
            while (active) // 第一行{
                // 代码
            }
        }
        public void stop()
        {
            active = false; // 第二行
        }
    }
  ```
  + 通常情况下，在一个线程调用 run() 方法（在 Runnable 开启的线程），在另一个线程调用 stop() 方法。 如果 第一行 中缓冲区的 active 值被使用，那么在 第二行 的 active 值为 false 时循环不会停止。
  但是以上代码中我们使用了 volatile 修饰 active，所以该循环会停止。

## Java Stream, File, IO
### 控制台输出
+ 为了获得一个绑定到控制台的字符流，可以把 System.in 包装在一个 BufferedReader 对象中来创建一个字符流
  ```java
  import java.io.*;
  public class BRRead{
      public static void main(String[] args){
          char c;
          BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
          System.out.println("press q to quit.");
          do {
              c = (char) br.read();
              System.out.println(c);
          } while (c!='q');
      }
  }
  ```
  其中，BufferedReader.read()用于读取一个字符，而BufferedReader.readline()用于读取一个字符串。

  ### 其他的以后再学

## Java异常处理
+ 所有的异常类都是从java.lang.Exception继承的子类
+ 捕获异常方法：try、catch关键字
  ```java
  try
  {
      //codes
  } catch(//ExceptionName e1)
  {
      //codes
  } catch(//ExceptionName e2)
  {
      //codes
  } finally
  {
      //codes
  }
  ```

## 