# 树
## 定义
+ 节点的**深度**指的是从root到该节点的路径的长度
+ 节点的**高度**指的是从该节点到离他最远的叶子节点的路径的长度
+ k叉树：每个节点最多只有k个节点的树
+ 满k叉数：每个节点要么没有子节点，要么有k个子节点
+ 完全k叉树：除了最后一层，其他层都是满的
+ 完美k叉树：所有的叶子节点高度均为0，同时所有非叶子节点都有k个子节点

## 树的表示
+ 朴素表示法
  ```
  struct Node {
      Data data;
      Node* parent;
      Node* left;
      Node* right;
  }
  ```
+ 左孩子右兄弟表示法：可以表示多叉的树结构
  ```
  struct Node{
      Data data;
      Node* father
      Node* firstChild;
      Node* nextSibling;
  };
  ```

## 二叉树
+ 二叉树是指每个节点至多只有两个节点的树
+ full binary tree：每个节点只有0个或者2个子节点
+ complete binary tree：除了最后一层其他层的节点都是满的
+ perfect binary tree：所有非叶节点都有两个子节点
  
## 树的遍历
+ 前序遍历（preorder traversal）：首先输出父节点，然后依次左子节点，右子节点
+ 后序遍历（postorder traversal）：首先左子节点，其次右子节点，父节点
+ 中序遍历（inorder traversal）：左子节点，父节点，右子节点

应用：
列出目录结构
