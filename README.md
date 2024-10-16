# llvm-learn

vscode-extensions

* graphviz interactive preview
* office viewer(markdown editor)

env

* apt install llvm clang graphviz build-essential

compile a c program with llvm to get cfg

* clang -S -emit-llvm test.c -o test.ll
* opt -passes=dot-cfg test.ll
* option: dot -Tpng -o test.png .main.dot

compile linux with llvm to get cfg

* python -m venv ~/venv00
* pip install [wllvm](https://github.com/travitch/whole-program-llvm)
* export LLVM_COMPILER=clang
* make CC=clang defconfig
* [option]make menuconfig
* make CC=wllvm LLVM=1
* extract-bc vmlinux.bc

wllvm

* wllvm:comiple c code
* wllvm++:compile c++ code
* extract-bc:extract the bitcode from a build product
* wllvm-sanity-checker:dectect configuration
* usage: export LLVM_COMPILER=clang (must), make CC=wllvm (must)
