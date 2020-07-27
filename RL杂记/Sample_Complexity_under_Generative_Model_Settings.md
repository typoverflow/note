# Sample Complexity under Generative Model Settings

+ by [Li Ziniu](liziniu.org), based on the materials [here](liziniu.org/docs/rl-generative-model.pdf)

## Learning Theory for SL
### Underlying Theory
$$ \mathbb{E}[l(f)]-\mathbb{E}[l(f^*)] = (\mathbb{E}[l(f)]-\mathbb{E}[l(f^*_n)])+(\mathbb{E}[l(f^*_n)]-\mathbb{E}[l(f^*_{\mathcal{E}})])+(\mathbb{E}[l(f^*_{\mathcal{F}})]-\mathbb{E}[l(f^*)]) $$
+ TODO

### Challenges
+ (Exploration): the agent does not have the knowledge about valuable samples
+ (Learning over multiple distribution): agent should learn the policy from all possible datasets (may not be iid)
+ (Sequential decision-making): delayed feedback

### Sample Complexity for RL
+ The **PAC(Provably approximation correct) complexity** of RL is defined as: how many instances(m) do we need to find a good policy function with the optimality gap $\epsilon$ with high probability $1-\sigma$
+ **generative model $ \mathcal{M} $**: we can directly reset it to any state $s_t$