# The Relational Model
## The Cap Database
+ more columns
+ more rows
+ more tables
  + unique identifier
## 术语
|关系模型|关系数据库管理系统（SQL）|文件系统|
|:-----:|:-----:|:-----:|
|Relation|Table|File of Records|
|Attribute|Column|Field|
|Tuple|Row|Record|
|Schema|Table Heading|Type of Record|

+ Definition
  + Database
    + a set of named tables, or relations
    ```
    CAP = {CUSTOMERS, AGENTS, PRODUCTS, ORDERS}
    ```
  + Headings of table, or schema

+ Notes
  + 数据表的行的数量一般是可以变化的，并且每一个行并不以“姓名”来标注
  + 数据表的列名一般不变化，并且每个属性的名字是被记住的
+ **数据独立性**
  + answers to a question must still answer the question even if all the data changes
  + 简而言之就是查询系统、应用软件和数据之间是相互独立的，改变数据并不影响使用

+ Column type （Domain， Datatype）
  + Domain（city）：合法的城市名称的集合
  + 简而言之就是能够被赋值给city的值的集合
  + Column Type可能出现的问题
    + 完整性：已有的数据类型不一定能够覆盖domain
    + 特殊类型：数据库的不同位置处的city可以取的值也不同

+ 关系代数（Relation Algebra）
  + 笛卡尔乘积（Cartesian Product）
    + CID×CNAME×CITY×DISCNT得到一个四元组(w, x, y, z)，其中$x\in Domain(CID)$,$y\in Domain(CNAME)$, $z\in Domain(CITY)$, $z\in Domain(DISCNTS)$
    + 想想看为什么数据库中的每一行被称为tuple
    + 那么每一个顾客都是上面的四元组的一个元素，即$CUSTOMERS\subseteq CID×CNAME×CITY×DISCNT$

## Relation Rules
1. First Normal Form Rule
   + columns that hav multi-valued attributes (repeating fields) or have any internal structure (record) are not permitted.
   + 对于属性含有内部结构的数据表，为了将它们转化为关系型数据表，可以将含有内部结构的属性合并或者拆分为两个属性
   + 对于属性含有多值的数据表，可以将它们横向展开成多个属性或者拆分成多个record。但是前者造成很多空数据，有空间浪费；后者造成数据冗余性的空间浪费。
2. Accsess Rows by Content Only Rule
   + 只能通过内容和属性的值来确定是哪一个entry
   + 这意味着：
     + no order to the rows
     + no order to the columns
3. The Unique Row Rule
   + 任意两行不能在所有的属性里面都相同
   + 因此意味着：数据库是一系列无序的tuple的集合。
   + 但是有时这个原则也有被打破的情况，但是这时这个表就不能被称作“关系”（relation）。在具体的数据库应用的实践中如果不允许打破这个原则，则需要给表加上约束定义。
4. Entity Integrity Rule
   + 主关键字的属性不能取空值

## 关键字，超级关键字和空值（Keys，Superkeys， NULL Values）
+ Superkey
  + 一系列属性的集合，这些属性具有uniqueness，即任何tuple在superkey下都不同
  + Key实际上时最小的Superkey
+ Table Key/Candidate Key
  + 定义：属性的一个子集，使得任何两个tuple在这个子集下的取值不是完全一样的，并且没有这个子集更小的子集具备上述性质。实际上是最小的超关键字
+ Primary Key
  + 定义：能够直接区分每一条tuple的单一关键字，通常形似PID、SID等等，叫做主关键字
+ **关键字定理**
  + 每一张关系表都能找到关键字
+ 空值
  + 特定的值未知，但是想要记录这条记录时，可以使用空值。
  + 空值是一个特殊的数值类型，它和空字符串以及0是不同的数据类型。
  + 不同的数据库管理系统对于空值的处理不一样。

## 关系代数
+ 代数操作
  + 交并差乘
    + 四者都不改变原有关系表的关系模式
  + PROJECT
    + 选定一组属性中的某些属性，然后返回一个新表，使得新表中在选择属性下相同的元素只能有一个。有一点去重的意味。
    + 符号：$R[ ]$或$\pi$
  + SELECT
    + 给定一个条件表达式，在表中返回满足这个条件的元组
    + 符号$A...where...B$
  + JOIN
    + 实现跨关系表的简便访问表示
    + 对于A join B， 当A和B中相同的属性的值也相同时，其余不同的属性会合并成同一个row的记录。
    + 如果这两个表的表头没有相同属性，那么$R\infty S=RxS$
    + 如果这两个表的属性全部相同，那么$R\infty S=R\cap S$
    + 符号$\infty$
    + 自然连接join存在的意义：简化类似(AxB) where ...的关系模式，但是一定要注意两张表里面的同名属性代表的意义是不是一样的！
  + DIVISION
    + 符号$\div$
    + 设header(A)={A1,A2...An,B1,B2...Bn},header(B) = {B1, ...Bn},则header(A/B)={A1,A2..An},要求header(B)属于header(A)
    + 直观意义上的含义是，与B不同的属性值相同的一些行，如果他们能同时遍历B中各行的所有可能，这样的行在去除与B相同的属性后合并成一个row加入到结果的表中。
  + 表的赋值
  + 性质
    + 如果R=TxS，则$T=R\div S,S = R\div T$
    + 如果$T = R\div S$，则$TxS\$ 
  + $S:=R$

## 相容表
+ 如果两个表的关系模式（表头）是一样的，并且每一个属性的论域、语义都是相同的；或者关系模式不同，但是能够找到这样的一一对应关系，使得一一对应的属性名的论域、语义相同，那么我们认为这两个表相容。

## 关系查询实例
> eg. 如果有四张表，CUSTOMERS，PRODUCTS， AGENTS， ORDERS，现在要选出所有的城市，使得这些城市的customers的discnt小于10%，或者agents的percent小于6%  
> **解**: T1 = (C where discnt < 10)[City]  
>     T2 = (A where percent < 6)[City]  
>     $T = T1 \cup T2$

> eg.找到cname and city of costomers and aname of agents taht the customers lives in the same city with agents  
> solution: ((CxA) where C.city=A.city)[C.cname, C.city, A.aname]  
> attention: this solution cannot be divide into to steps  
> 1. T = ((CxA) where C.city=A.city)  
> 2. R = T[C.cname, C.city, A.aname]  
> because we dont have C.name/C.city/A.aname in T!!! 　一旦脱离了C，C.name属性就无法再继续访问了。因此要时刻检验需要检索的属性还在不在当前表内

> eg. find cid of customers who have a highest discnt in all customers  
> solution:  
> 1. $R_1 = C[cid]$
> 2. $R_2 = ((CxS)　where　C.discnt<S.discnt)[C.cid]$
> 3. $T = R_1-R_2$

> eg. find the names of the customers who have ordered product 'p01'  
> solution:  
> $(C\infty P) where　pid='p01'[C.cname]$

> eg. get names of customers who order at least one product costing $0.5  
> solution:  
> T1: todo

