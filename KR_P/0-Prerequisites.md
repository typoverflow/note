# Prerequisites


## Satisfiability
for formula $A$
+ If $A$ is true in $I$, then $I$ satisfies $A$ and $I$ is **a model of** $A$, denoted by $I\models A$
+ $A$ is **satisfiable** iff there exists a model for $A$
+ $A$ is **unsatisfiable** iff $A$ is false in all interpretations
+ $A$ is **valid** or **tautology** iff $A$ is true in all interpretations. (denoted by $\models A$)
+ formula $A$ **entails** $B$, (denoted by $A\models B$), iff all models of $A$ are momdels of $B$
+ formual $A$ is **equivalent** to $B$, (denoted by $A\equiv B$) iff models of $A$ are the same as the models of $B$

#### Lemma
for formula $A$ and $B$
+ $A$ is valid iff $\neg A$ is unsatisfiable
+ $A$ is satisfiable iff $\neg A$ is not valid
+ $A$ is valid iff $A\equiv true$
+ $A\equiv B$ iff $A\leftrightarrow B$ is valid
+ 检测可满足性是NP问题
+ 检测有效性是co-NP问题

## Reasoning Methods
+ to prove validity/satisfiability

### Refutational Reasoning Method
**Idea**: no algorithms can directly decide A is valid or not, while there exsis algorithms that can easily decide $\neg A$ is unsatisfiable or not
+ **soundness**
  + 如果推理算法$RM$对公式集$\Phi$是正确的，则
    + 若$RM$判定$\Phi$的任意子集$S$为satisfiable，则该子集的确是satisfiable
    + 若$RM$判定$\Phi$的任意子集$S$为unsatisfiable，则该子集的确是unsatisfiable
    + 换言之，$RM$能得到和实际情况一致的结果
+ **completeness**
  + 如果推理算法$RM$对公式集$\Phi$的任意子集$S$是（拒绝意义上）完备的，则
    + 若$S$是unsatisfiable的，那么$RM(S)$一定能终止并且返回unsatisfiable

### Resolution
#### Normal Form
+ **literal**: atom $p$ or its negation $\neg p$
+ **Clause**: a disjuction of literals $L_1 \lor L_2...\lor L_n$, or $\{L_1, L_2,..., L_n\}$
+ **CNF**: conjunction of clauses
+ **CNF of a formula**: A formula $B$ is **a CNF of a formula** $A$ if $A\equiv B$ and $B$ is CNF
+ **原始公式的可满足性转换为Clauses的可满足性检测**

然而，将原始公式使用**基于规则**的方法转换为CNF范式可达到指数级复杂度，因此我们使用结构化的转换方法(Structual Tranformation).

#### Structual Transformation
+ [Thm]: $F[G]$ is *satisfiable* iff $F[n_G]\land (n_G\leftrightarrow G)$ is *satisfiable*
  + $n_G$ is a fresh propositional variable. (So $n_G$ can be seen as a name for $G$)
+ Introduce names recursively for every non-literal subformula in the original formula
+ Increasing the size by an additional **constant** factor
+ New formula is only *equiv-satisfiable* as the original formula, while **the model changes**!
+ 如下图，逐步裂开
![](img/2020-02-23-22-09-57.png)
![](img/2020-02-23-22-17-18.png)


**与基于规则的转换方法的不同之处**
+ 基于规则的方法在model上保持一致，而Structual Transformation不确定model保持一致
+ 复杂度不同，一个是指数级，一个是线性的

#### Propositional Resolution
+ Propositional Resolution inference system $\mathbb{BR}$, consists of the following inference rules
![](img/2020-02-23-22-30-14.png)
+ 想法
  + 证明原公式集不可满足
  + 在CNF情况下，如果需要找到一个model，则必须clauses同时为True
  + 通过上述两公理，不断进行消解直到最后，若得到False则推出矛盾
+ 例子如下，注意，根据老师的说法，这里的横线代表的是语义上的推导而非语法上的公理
![](img/2020-02-23-22-36-06.png)

#### Soundness
+ An inference is sound if the conclusion of this inference logically follows from the premises
+ An inference rule is sound if all its inference are sound
+ An inference system is sound if all its inference rules are sound
+ **【Soundness】**: An inference system $\mathbb{I}$ is sound if for any set of formulas $S$ we have
$$S\vdash_{\mathbb{I}}\perp\ \  implies\ \ S\models \perp$$

#### Completeness
An inference system $\mathbb{I}$ is refutationally complete if for any set of formulas $S$ we have
$$S\models\perp \ \  implies \ \ S\vdash_{\mathbb{I}}\perp$$

#### Simplication rules
+ 化简律在饱和过程中将不影响正确性和完备性的子句去除
+ **【Tautology Elimination】(TE)**: $S\rightarrow S-{T}$
+ **【Subsumption Elimination】(SE)**: $S\rightarrow S-{D}$ where there is $C\in S$ such that $C\subset D$ (消去大的)
![](img/2020-02-23-23-02-58.png)

### DPLL
#### Unit Propagation
![](img/2020-02-23-23-09-23.png)
+ 首先要有unit
+ 实际上是对于已知的式子，将相反的式子直接划去
+ 如果不存在unit或需要的unit不够，则使用下面的Decide和Backtrace
+ Example
![](img/2020-02-23-23-12-21.png)
#### Horn Clauses
+ A clause is called Horn if it contains at most one positive literal

#### Decide and Backtrance
+ 假设某个unit为1/0 （Decide）
+ 如果Decide结果后推出False，则Backtrace假设为相反量
+ 类似于树搜索

![](img/2020-02-23-23-21-20.png)

#### DPLL Backjump
#### Lemma Learning
