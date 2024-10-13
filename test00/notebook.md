## .C语言程序

main函数：定义了两个规模为10的int数组a和b，两个int数c和d，先后调用了compute和printArray函数

compute函数：参数为两个数组，和两个整型，进行计算

printArray函数：参数为一个数组和一个数组长度，打印数组内容

## .ll程序

### 1. 模块信息

```llvm
; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"
```

- 这些行给出了模块的基本信息，包括模块 ID、源文件名、目标数据布局和目标三元组（表示平台架构）。这些信息对编译器生成优化代码很重要。

> `target datalayout` 是 LLVM IR 中用于描述数据布局的属性，它指示编译器如何在内存中对齐和布局数据结构。数据布局对于优化内存访问和确保数据在特定平台上的正确性至关重要。一个 `target datalayout` 字符串通常包含多个部分，每个部分由特定的字符和符号组成。以下是该字符串的典型部分及其含义：
>
> 1. **基本格式**：
>
>    ```
>    "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
>    ```
> 2. **各部分含义**：
>
>    - **`e`**：表示字节序（Endian），`e` 为小端（little-endian），`E` 为大端（big-endian）。
>    - **`m`**：表示内存模型的字节对齐。
>    - **`p`**：表示指针的大小和对齐，格式为 `p<address_space>:<size>:<alignment>`。
>      - 例如 `p270:32:32` 表示：
>        - 地址空间 270 的指针
>        - 32 位大小
>        - 32 位对齐
>    - **`i`**：表示整数类型的大小和对齐，格式为 `i<bitwidth>:<alignment>`。
>      - 例如 `i64:64` 表示 64 位整数，64 位对齐。
>    - **`f`**：表示浮点类型的大小和对齐，格式为 `f<bitwidth>:<alignment>`。
>      - 例如 `f80:128` 表示 80 位浮点数，128 位对齐。
>    - **`n`**：表示数字类型的大小和对齐，格式为 `n<bitwidth>:<alignment>`。
>      - 例如 `n8:16:32:64` 表示 8 位、16 位、32 位和 64 位数字类型的对齐。
>    - **`S`**：表示栈的对齐方式。
>      - 例如 `S128` 表示栈对齐为 128 位。

### 2. 全局常量定义

```llvm
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
```

- 定义了一个字符串常量 `@.str`，用于格式化输出（`printf` 格式字符串）。
- 它是一个字符数组，内容为 `"%d "`，用于打印整数。

```llvm
@__const.main.a = private unnamed_addr constant [10 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 0], align 16
```

- 定义了一个包含 10 个整数的数组 `@__const.main.a`，初始值为 1 到 9，最后一个元素为 0。
- 这个数组将用于后续的计算。

### 3. `@compute` 函数定义

```llvm
define dso_local void @compute(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) #0 {
```

- 定义了 `@compute` 函数，它是一个没有返回值的函数，接受两个指针和两个整数作为参数。
- `%0` 是输入数组，`%1` 是输出数组，`%2` 和 `%3` 是整数参数。

```llvm
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
```

- 分配了五个局部变量：两个指针 `%5` 和 `%6`，以及三个整数 `%7`、`%8` 和 `%9`。

```llvm
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  store i32 0, ptr %9, align 4
```

- 将函数参数存储到局部变量中。
- `%9` 初始化为 0，用作循环计数器。

### 4. 循环开始

```llvm
  br label %10
```

- 跳转到标签 `%10`，开始循环。

### 5. 循环体

```llvm
10:                                               ; preds = %27, %4
  %11 = load i32, ptr %9, align 4
  %12 = icmp slt i32 %11, 10
  br i1 %12, label %13, label %30
```

- 从 `%9` 加载计数器的值 `%11`。
- 检查 `%11` 是否小于 10，如果是，则跳转到 `%13`（进行计算），否则跳转到 `%30`（结束循环）。

### 6. 计算部分

```llvm
13:                                               ; preds = %10
  %14 = load ptr, ptr %5, align 8
  %15 = load i32, ptr %9, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds i32, ptr %14, i64 %16
  %18 = load i32, ptr %17, align 4
```

- 从 `%5` 加载输入数组的指针 `%14`。
- 从 `%9` 加载当前计数器值 `%15`，并将其扩展为 64 位整数 `%16`。
- 使用 `getelementptr` 获取输入数组中对应元素的地址 `%17`，然后加载该元素的值 `%18`。

### 7. 计算和存储结果

```llvm
  %19 = load i32, ptr %8, align 4
  %20 = mul nsw i32 %18, %19
  %21 = load i32, ptr %7, align 4
  %22 = add nsw i32 %20, %21
```

- 从 `%8` 加载第二个整数参数 `%19`。
- 计算 `%18`（输入数组元素）与 `%19` 的乘积 `%20`。
- 加上 `%21`（从 `%7` 加载的值），得到最终结果 `%22`。

```llvm
  %23 = load ptr, ptr %6, align 8
  %24 = load i32, ptr %9, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds i32, ptr %23, i64 %25
  store i32 %22, ptr %26, align 4
```

- 从 `%6` 加载输出数组的指针 `%23`。
- 类似地，获取输出数组中对应位置的地址，并将结果 `%22` 存储到该位置。

### 8. 更新计数器并循环

```llvm
27:                                               ; preds = %13
  %28 = load i32, ptr %9, align 4
  %29 = add nsw i32 %28, 1
  store i32 %29, ptr %9, align 4
  br label %10, !llvm.loop !6
```

- 从 `%9` 加载当前计数器值 `%28`，加 1 并存储回 `%9`。
- 跳转到 `%10`，继续循环。

### 9. 循环结束

```llvm
30:                                               ; preds = %10
  ret void
}
```

- 如果计数器不小于 10，跳转到 `%30`，结束函数并返回。

### 10. `@printArray` 函数定义

```llvm
define dso_local void @printArray(ptr noundef %0, i32 noundef %1) #0 {
```

- 定义了 `@printArray` 函数，接受一个指针和一个整数作为参数。

```llvm
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
```

- 分配了三个局部变量，用于存储输入指针和计数器。

```llvm
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  br label %6
```

- 将参数存储到局部变量，并初始化计数器为 0。

### 11. 打印循环

```llvm
6:                                                ; preds = %17, %2
  %7 = load i32, ptr %5, align 4
  %8 = load i32, ptr %4, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %10, label %20
```

- 加载计数器和数组长度，检查计数器是否小于长度。
- 如果是，跳转到 `%10`（打印元素），否则跳转到 `%20`（结束函数）。

### 12. 打印元素

```llvm
10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 8
  %12 = load i32, ptr %5, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds i32, ptr %11, i64 %13
  %15 = load i32, ptr %14, align 4
  %16 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %15)
  br label %17
```

- 从数组指针中获取当前元素的值，并调用 `printf` 输出该值。

### 13. 更新计数器并循环

```llvm
17:                                               ; preds = %10
  %18 = load i32, ptr %5, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, ptr %5, align 4
  br label %6, !llvm.loop !8
```

- 更新计数器并返回到 `%6`，继续循环检查。

### 14. 返回

```llvm
20:                                               ; preds = %6
  ret void
}
```

- 如果所有元素都打印完，返回。

### 15. `@main` 函数定义

```llvm
define dso_local i32 @main() #0 {
```

- 定义了程序的入口点 `@main` 函数，返回一个整数。

```llvm
  %1 = alloca i32, align 4
  %2 = alloca [10 x i32], align 16
  %3 = alloca [10 x i32], align 16
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
```

- 分配了多个局部变量，包括两个数组 `%2` 和 `%3`。

```llvm
  store i32 0, ptr %1, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %2, ptr align 16 @__const.main.a, i64 40, i1 false)
  call void @llvm.memset.p0.i64(ptr align 16 %3, i8 0, i64 40, i1 false)
```

- 初始化局部变量 `%1` 为 0。
- 使用 `llvm.memcpy` 将常量数组复制到 `%2`，并使用 `llvm.memset` 将 `%3` 清零。

### 16. 准备调用 `compute`

```llvm
  store i32 5, ptr %4, align 4
  store i32 3, ptr %5, align 4
  %6 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 0
  %7 = getelementptr inbounds [10 x i32], ptr %3, i64 0, i64 0
```

- 将整数 5 存储到 `%4`，3 存储到 `%5`。
- 获取数组 `%2` 和 `%3` 的指针。

### 17. 调用 `compute` 和 `printArray`

```llvm
  %8 = load i32, ptr %4, align 4
  %9 = load i32, ptr %5, align 4
  call void @compute(ptr noundef %6, ptr noundef %7, i32 noundef %8, i32 noundef %9)
  %10 = getelementptr inbounds [10 x i32], ptr %3, i64 0, i64 0
  call void @printArray(ptr noundef %10, i32 noundef 10)
```

- 从 `%4` 和 `%5` 加载参数，调用 `compute` 函数。
- 然后调用 `printArray` 函数打印 `%3` 中的内容。

### 18. 返回

```llvm
  ret i32 0
}
```

- 最后，`@main` 函数返回 0，表示程序正常结束。

### 19. 其他声明和属性

```llvm
declare i32 @printf(ptr noundef, ...) #1
```

- 声明了 `printf` 函数。

```llvm
; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #2
```

- 声明了 `llvm.memcpy` 和 `llvm.memset` 函数，用于内存操作。
