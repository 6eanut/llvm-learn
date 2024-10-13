# llvm-learn

vscode-extensions

* graphviz interactive preview
* office viewer(markdown editor)

env

* apt install llvm clang graphviz

steps

* clang -S -emit-llvm test.c -o test.ll
* opt -passes=dot-cfg test.ll
* option: dot -Tpng -o test.png .main.dot
