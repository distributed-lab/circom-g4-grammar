# Circom G4 Grammar Spec

This repository represents a Circom grammar using ANTLR tool. 

## Grammar Compatibility

Source: https://github.com/iden3/circom/blob/master/parser/src/lang.lalrpop

Issues: 

- The grammar described in the repository is not official one. Therefore relevant consequences may occur:
  - The grammar may not be up-to-date.
  - Some structures that are valid in the official grammar are not valid in this one, due to one of the following reasons: redundancy, and sanity

Still, we are trying out best to cover 99.(9)% of the existing code, providing a simple and efficient structure. The code is campable of parsing whole `circomlin` and `iden3-circuits`. 

## Contribution

First of all you need to clone the repository

```shell
git clone git@github.com:distributed-lab/circom-parser.git
cd circom-parser
```

And then you need to install dependencies

```shell
go mod tidy
```

After that, you can use following commands to sync gitmodules

```shell
git submodule update --init
git submodule update --remote
```

After initiating gitmodules you are ready to generate go binding for the grammar and test it (both of these action are in one command)

```shell
make
```
