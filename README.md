# 中国房贷计算程序 #

该程序主要功能为根据贷款金额、时长和利率等信息计算每月需要还款金额以及全部还完所需交纳利息。此外还提供提前还款后还款变动情况和总利息变动情况等。

暂不提供GUI版本。采用Python、Java、Common Lisp、C/C++和汇编语言编写，其中前四种语言实现与平台无关，汇编语言暂只支持Windows平台，并且C/C++和汇编语言的可执行文件暂只提供Windows版本。

## Python版本 ##
在Windows 10平台的Python 3.7.4上测试通过。

## Common Lisp版本 ##
在Windows 10平台的Steel Bank Common Lisp上测试通过。

### 加载方法 ###
在命令提示符界面进入脚本目录，输入
``` console
sbcl --load "HouseLoanCal.lisp"
```
或加载编译好的文件
``` console
sbcl --load "HouseLoanCal.fasl"
```
或者进入sbcl程序，输入
``` console
(load "HouseLoanCal.lisp")
```
或
``` console
(load "HouseLoanCal.fasl")
```

## C语言版本 ##
在Windows 10平台上用MSVC 2019和MinGW64 4.3.5均编译通过。

### 编译方法 ###
在C语言程序目录下新建一个目录，一般命名为build，在命令提示符界面进入build目录。如果使用MSVC编译则直接输入
``` console
cmake ..
```
如果使用MinGW编译则输入
```console
cmake .. -G "MinGW Makefiles"
```
成功执行后输入
``` console
cmake --build . --config Release --target install
```
编译成功。

## 汇编语言版本 ##
32位版本使用masm32编译，64位版本使用masm64编译。由于编译器不支持在编译时改变输出编码格式，因此源代码采用Chinese GBK编码使得中文能够在中文版Windows 10上正常显示。

### 说明 ###
64位汇编中Windows API前四个参数采用寄存器传参数的方式，但是自己写的过程仍然可以全部采用栈传参的方式，只是需要自己在调用完过程后增加rsp的值保证栈平衡。Windows API传参方式可能是由于系统编译所致，有的API函数可能不需要保存传参寄存器中的值，即在调用前不用抬栈，但是清楚每个API的细节是一件很麻烦的事，因此在调用API前总是抬栈，调用自己写的过程则不用这么麻烦。

由于汇编语言比较繁琐，因此不提供其它功能。
