# 栈的应用

## 括号匹配
```
CheckParen(str):
Stack s;
int i=1;
while (str[i] != NULL)
    if (str[i] is '(' or '[' or '{')
        s.push(str[i]);
    if (str[i] is ')' or ']' or '}')
        if (s.empty())
            return False;
        if (s.pop() and str[i] mismatch)
            return False;
    i++;
return s.empty()
```
## 计算后缀表达式的值
```
EvalRPN(str):
Stack s;
while ((token=NextToken(str)) != NULL)
    if (token is an operand)
        s.push(token)
    else
        res = PopOperandAndCalc(s, token)
        s.push(res)
return s.pop()
```

## 实现函数调用
略

## 去除递归
+ 递归方法
```FackRec(n):
if (n==1)
    return 1;
else
    return m*FactRec(n-1);
```
+ 栈方法
```c++
struct Frame{
    int val;
    int acc; //用于作为被标志量以及向上传递计算值。
    Frame* prevFrame;
}

Stack s;
s.push(Frame(n, -1, NULL))
while(!s.empty())
    frame=s.peek();
    if frame.val() <= 1
        frame.acc = 1;
    if (frame.acc != -1)
        res = frame.val*frame.acc
        if frame.prevFrame!=NULL
            frmae.prevFrame->acc=res
        s.pop()
    else s.push(Frame(frame.val-1, -1, &frame))
return res
```

+ 尾递归：最后一步执行完递归调用后立即返回
  + 尾递归可以高效地转化为迭代。因为不需要记住递归过程中产生的许多中间变量。把最后一次递归产生的东西直接返回，省去了将结果一步一步向上传递的过程，只需要更新参数就可以了。