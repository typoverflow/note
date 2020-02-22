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
+ completeness
  + 如果推理算法$RM$对公式集$\Phi$的任意子集$S$是（拒绝意义上）完备的，则
    + 若$S$是unsatisfiable的，那么$RM(S)$一定能终止并且返回unsatisfiable

### DPLL
+ Truth Table + pruning, actually.

### Resolution
#### Normal Form
+ **literal**: atom $p$ or its negation $\neg p$
+ **Clause**: a disjuction of literals $L_1 \lor L_2...\lor L_n$, or $\{L_1, L_2,..., L_n\}$
+ **CNF**: conjunction of clauses
+ **CNF of a formula**: A formula $B$ is **a CNF of a formula** $A$ if $A\equiv B$ and $B$ is CNF
+ **原始公式的可满足性转换为Clauses的可满足性检测**

然而，将原始公式使用**基于规则**的方法转换为CNF范式可达到指数级复杂度，因此我们使用结构化的转换方法(Structual Tranformation).
