---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

# layout: home
usemathjax: true
---

{% include mathjax.html %}

# Fermat's Last Theorem for Exponent 3

## Introduction

[...]

- Sum of cubes equals a cube isn't informative
- Product of coprimes equals a cube is informative (implies that each factor is a cube)
- To express $a^3 + b^3$ as a product we need to work in $\mathbb{Z}[e^{\frac{2\pi i}{3}}]$ which is already in Mathlib

$$a^3+b^3 = (a+b)(a^2 - ab + b^2)
          = (a+b)(a + e^{\frac{2\pi i}{3}} b )(a+ e^{\frac{4\pi i}{3}} b)$$

## Build the Lean files

To build the Lean files of this project, you need to have a working version of Lean.
See [the installation instructions](https://leanprover-community.github.io/get_started.html) (under Regular install).

To build the project, run `lake exe cache get` and then `lake build`.

## Build the blueprint

To build the web version of the blueprint, you need a working LaTeX installation.
Furthermore, you need some packages:

```
sudo apt install graphviz libgraphviz-dev
pip3 install invoke pandoc
cd .. # go to folder where you are happy clone git repos
git clone git@github.com:plastex/plastex
pip3 install ./plastex
git clone git@github.com:PatrickMassot/leanblueprint
pip3 install ./leanblueprint
cd sphere-eversion
```

To actually build the blueprint, run

```
lake exe cache get
lake build
inv all
```


## References

Hindry (2011) [Arithmetics](https://doi.org/10.1007/978-1-4471-2131-2). *Springer*.