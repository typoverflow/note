# Python中的multiprocessing
Python的multiprocessing模块使用和threading模块相似的API，提供了用于编写多进程程序所需要的函数和功能。在Python语言中，由于Global Interpreter Lock的存在，多线程程序的子线程并不能并发地在多核cpu上运行。而multiprocessing模块则实际上使得程序编写者能够真正意义上利用多核cpu的并发计算功能。

## `Process`类
+ 使用`Process`创建，参数为子进程所要执行的函数和函数参数
+ 使用`start()`方法开始，使用`join()`方法阻塞直到子进程结束

## 进程间的数据交换
+ 队列：Queue
```python
from multiprocessing import Process, Queue

def f(q):
    q.put([42, None, 'hello'])

if __name__ == '__main__':
    q = Queue()
    p = Process(target=f, args=(q,))
    p.start()
    print(q.get())    # prints "[42, None, 'hello']"
    p.join()
```
+ 管道：Pipes
```python
from multiprocessing import Process, Pipe

def f(conn):
    conn.send([42, None, 'hello'])
    conn.close()

if __name__ == '__main__':
    parent_conn, child_conn = Pipe()
    p = Process(target=f, args=(child_conn,))
    p.start()
    print(parent_conn.recv())   # prints "[42, None, 'hello']"
    p.join()
```
+ 可以发现实现方式基本都是将通信用的对象作为子进程函数的参数

## 进程间的同步
+ multiprocessing模块使用锁对进程进行数据同步
```python
from multiprocessing import Process, Lock

def f(l, i):
    l.acquire()
    try:
        print('hello world', i)
    finally:
        l.release()

if __name__ == '__main__':
    lock = Lock()

    for num in range(10):
        Process(target=f, args=(lock, num)).start()
```

## 进程间共享数据
+ 进程间共享的数据可以使用`Value`和`Array`进行传递
+ 直接将数/数组作为参量赋给子进程只能实现主进程向子进程的数据拷贝，但是通过`Array`和`Value`传递的共享变量在内存中只有一份拷贝

## Pool：进程池
+ Pool提供了对一组子进程进行管理的方式，其中包括`map`, `imap_unordered`, `apply_sync`等多种将workload分配到池中进程的方法
```python
from multiprocessing import Pool, TimeoutError
import time
import os

def f(x):
    return x*x

if __name__ == '__main__':
    # start 4 worker processes
    with Pool(processes=4) as pool:

        # print "[0, 1, 4,..., 81]"
        print(pool.map(f, range(10)))

        # print same numbers in arbitrary order
        for i in pool.imap_unordered(f, range(10)):
            print(i)

        # evaluate "f(20)" asynchronously
        res = pool.apply_async(f, (20,))      # runs in *only* one process
        print(res.get(timeout=1))             # prints "400"

        # evaluate "os.getpid()" asynchronously
        res = pool.apply_async(os.getpid, ()) # runs in *only* one process
        print(res.get(timeout=1))             # prints the PID of that process

        # launching multiple evaluations asynchronously *may* use more processes
        multiple_results = [pool.apply_async(os.getpid, ()) for i in range(4)]
        print([res.get(timeout=1) for res in multiple_results])

        # make a single worker sleep for 10 secs
        res = pool.apply_async(time.sleep, (10,))
        try:
            print(res.get(timeout=1))
        except TimeoutError:
            print("We lacked patience and got a multiprocessing.TimeoutError")

        print("For the moment, the pool remains available for more work")

    # exiting the 'with'-block has stopped the pool
    print("Now the pool is closed and no longer available")
```