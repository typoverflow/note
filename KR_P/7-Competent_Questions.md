# Competent Questions
+ Questions that help capture
  + Scope
  + Content
  + A form of evaluation

+ examples
  + How many pizzas are available?
  + Do pizzas come in different sizes?
  + Which pizzas do not have nuts?
  + Can I remove toppings from a pizza?
  + ...
+ If we can answer CQs, then the ontology is OK
+ If we can't, then the ontology needs to be expanded and enlarged

## Composition or Aggregation
+ Describe a whole by means of its parts

### Part and Whole
+ parts and wholes
  + examples
    + Car -- Iron
    + China -- Nanjing
    + Pie -- Slide of Pie
    + NJU -- You
+ *is part of* is the **Inverse** of *has part*
  + Cake hasPart Apple, while Apple isPartOf Cake
  + *Protege* can describe the **Inverse** relationship between concepts, and we are obligated to tag a property as Inversable if it can be inversed, otherwise loss of entailment and inference may be caused!