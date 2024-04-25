---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

# layout: home
usemathjax: true
---

# Fermat's Last Theorem for Exponent 3

A formalised proof of Fermat's Last Theorem for exponent 3 in the Lean proof assistant.

## Build Lean Files

To build the Lean files of this project, you need to have a working version of Lean.
For comprehensive guidance on installing Lean,
see [the installation instructions](https://leanprover-community.github.io/get_started.html)
under the section titled "Regular install".

To build the project, run `lake exe cache get` and then `lake build`.

## Build Blueprint

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
cd FLT3
```

To actually build the blueprint, run

```
lake exe cache get
lake build
inv all
```

## Main References

1. Hindry. [*Arithmetics*](http://dx.doi.org/10.1007/978-1-4471-2131-2).
2. Avigad and Massot. [*Mathematics in Lean*](https://leanprover-community.github.io/mathematics_in_lean/).
3. Avigad et al. [*Theorem Proving in Lean 4*](https://leanprover.github.io/theorem_proving_in_lean4/).
4. Macbeth. [*The Mechanics of Proof*](https://hrmacbeth.github.io/math2001/).
5. Velleman. [*How To Prove It With Lean*](https://djvelleman.github.io/HTPIwL/).
6. Christiansen. [*Functional Programming in Lean*](https://lean-lang.org/functional_programming_in_lean/).
7. De Moura and Ullrich. [*The Lean 4 Theorem Prover and Programming Language*](https://doi.org/10.1007/978-3-030-79876-5_37).
8. Limperg and From. [*Aesop: White-Box Best-First Proof Search for Lean*](http://dx.doi.org/10.1145/3573105.3575671).
9. Buzzard. [*Lean in 2024*](https://xenaproject.wordpress.com/2024/01/20/lean-in-2024/).
10. Lowry-Duda. [*FLT3 at Lean for the Curious Mathematician 2024*](https://davidlowryduda.com/flt3-at-lftcm2024/).