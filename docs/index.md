# Fermat's Last Theorem for Exponent 3

## Introduction

[...]

- Sum of cubes equals a cube isn't informative
- Product of coprimes equals a cube is informative (implies that each factor is a cube)
- To express $a^3 + b^3$ as a product we need to work in $\mathbb{Z}[e^{\frac{2\pi i}{3}}]$ which is already in Mathlib

$$a^3+b^3 = (a+b)(a^2 - ab + b^2)
          = (a+b)(a + e^{\frac{2\pi i}{3}} b )(a+ e^{\frac{4\pi i}{3}} b)$$

## References

Hindry (2011) [Arithmetics](https://doi.org/10.1007/978-1-4471-2131-2). *Springer*.