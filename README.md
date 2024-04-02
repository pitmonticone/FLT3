# Fermat's Last Theorem for Exponent 3

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-lightgrey.svg)](https://opensource.org/licenses/Apache-2.0)
[![CI](https://github.com/pitmonticone/FLT3/actions/workflows/push.yml/badge.svg)](https://github.com/pitmonticone/FLT3/actions/workflows/push.yml)
[![Documentation: Website](https://img.shields.io/badge/Documentation-Website-blue.svg)](https://pitmonticone.github.io/FLT3/docs/)
[![Blueprint: Website](https://img.shields.io/badge/Blueprint-Website-red.svg)](https://pitmonticone.github.io/FLT3/blueprint)
[![Blueprint: Paper](https://img.shields.io/badge/Blueprint-Paper-darkred.svg)](https://pitmonticone.github.io/FLT3/blueprint.pdf)

A formalised proof of Fermat's Last Theorem for exponent 3 in the Lean proof assistant.

## Build Lean Files

To build the Lean files of this project, you need to have a working version of Lean.
See [the installation instructions](https://leanprover-community.github.io/get_started.html) (under Regular install).

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