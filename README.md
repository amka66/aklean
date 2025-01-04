# aklean #

___A blueprint for [Lean 4](https://leanprover-community.github.io/index.html) projects including useful definitions and utilities for Lean development___

> This repo is primarily for personal use.
> It is included here for public use, in case anyone finds it useful.

## Overview ##

- This repository includes a [Lean 4](https://leanprover-community.github.io/index.html) package `aklean` with a mathlib dependency and minimum additional content.
- It can serve as a **blueprint** for new Lean projects -- clone or download the repository and copy over parts of it for quickly setting up a new Lean project.

## Getting Started ##

### Blueprint ###

1. Clone the repository, e.g., by running
```
$ git clone https://github.com/amka66/aklean.git
```
2. Copy over the relevant files.
3. Edit the files as needed.

`aklean` was set up using the built-in build system and package manager `lake` (Lean Make).
Lean 4 and `lake` were installed using the Lean version manager [`elan`](https://github.com/leanprover/elan).
Also note that the repo includes development environment settings; particularly, `git`, `make`, `VSCode`, and `DVC`.
