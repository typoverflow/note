# SQL语句
## 数据类型
+ CHARACTER(n)/CHAR(n)定长字符串
+ CHARACTER VARYING(n)/CHAR VARYING(n)变长
+ INTEGER
+ SMALLINT
+ BIGINT  
![](img/2019-10-24-01-30-14.png)

## 格式
+ 创建表  
  ![](img/2019-10-24-01-31-55.png)
  + { }、[ ]内均为可选。也就是说，可以选择是否指定主关键字，可以使用NOT NULL指定每一个条目的这个属性能否为非空。 
  + > ex:![](img/2019-10-24-01-34-44.png)
+ 选择语句  
  ![](img/2019-10-24-01-45-02.png)
  + 与关系代数的对应关系见后文

  
## 选择语句与关系代数的简单对应关系
+ 简单关系  
  ![](img/2019-10-24-01-48-02.png)
+ 笛卡尔乘积  
  ![](img/2019-10-24-01-48-27.png)
+ JOIN运算：查询条件必须显式地写在where语句中  
  ![](img/2019-10-24-01-50-46.png)
+ 



## 查询谓词
### IN、NOT IN
### The Qualified Conparison Predicate
### The EXISTS Predicate
### The Between Predicate
### The IS NULL Predicate
### The LIKE Predicate
