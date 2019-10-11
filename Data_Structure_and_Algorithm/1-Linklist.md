## LinkedList Data Structure
+ 实现方法
  + size(), get(i), set(i,x), add(i,x), remove(i)
+ 抽象数据类型
  + 适合实现Stack,FIFO Queue
  + 不适合实现Deque，因为无法轻松定位倒数第二个元素的地址，因此在尾部删除操作并不高效

## DLinkedList Data Structure
+ 实现方法同上
+ 适合实现Stack，FIFO Queue，Deque
+ 为了更方便的维护头指针和尾指针，引入哨兵元素sentinel
  + s.next指向链表的第一个元素，s.prev指向链表的最后一个元素，形成双向环形链表。
  + ```c++
    AddFirst(x):
    x.next = s.next;
    s.next.prev = &x;
    s.next = &x;
    x.prev = &s;
    ```

