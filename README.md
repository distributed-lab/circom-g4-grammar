# Circom G4 Grammar Specification

This repository provides a Circom grammar implementation in G4 format using the [ANTLR](https://www.antlr.org) tool. 

## Grammar Compatibility

Source: [Circom Parser Grammar](https://github.com/iden3/circom/blob/master/parser/src/lang.lalrpop)

### Issues

- The grammar described in this repository is unofficial. Consequently, the following issues may arise:
    - The grammar may not be up-to-date.
    - Some structures that are valid in the official grammar may not be valid in this version due to factors such as redundancy or complexity.

Despite this, we strive to cover 99.9% of the existing Circom code, offering a simple and efficient structure. The parser is capable of handling both `circomlib` and `iden3-circuits`.

## Contribution

To contribute, first clone the repository:

```shell
git clone git@github.com:distributed-lab/circom-parser.git
cd circom-parser
```

Next, install the dependencies:

```shell
go mod tidy
```

Then, synchronize the git submodules:

```shell
git submodule update --init
git submodule update --remote
```

After initializing the submodules, you are ready to generate the Go bindings for the grammar and run tests with a single command:

```shell
make
```
