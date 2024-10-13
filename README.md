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

---

试着用LLVM编译linux-5.4版本的内核，获取内核的CFG，然后确认以下几个问题：

1、CFG的基本单位是什么？基本块还是语句？

基本块

2、给定内核源码中的一个任意语句（非预处理，变量定义等语句），我们能在CFG中找到语句所处的位置吗？

能

3、给定一个变量定义语句（如 int a = 10;）我们能在CFG中找到它的位置吗？如果不能，我们能不能找到所有应用到这个变量（或其内部成员）的语句在CFG中的位置？

能找到吧

4、给定一个预处理语句(如#define, #include)，我们能在CFG中找到它的位置吗？

找不到
