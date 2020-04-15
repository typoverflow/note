# Ontology开发笔记

## 实验环境
+ Protege v5.0.0

## Ontology开发注意点
+ ValuePartition类一定要做到
  + 父类是所有子类之并
  + 子类互不相交
+ 除了ValuePartition类以外的类，也要注意指定互不相交关系
+ 要注意封闭性和存在性以及基数（Cardinality）之间的关系
  + 一般来说，一个concept的restriction要兼具存在性和封闭性
    + 比如在Sushi Ontology开发中，AvocadoMakiDish既要有contains some AvocadoMakiRoll也要有contains only AvocadoMakiRoll
  + 另一方面，基数其实只是一种对some的量化描述，其本身不具备封闭性性质！