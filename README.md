# C-call-graph-producer

[![Security Status](https://s.murphysec.com/badge/ljs-2002/C-call-graph-producer.svg)](https://www.murphysec.com/p/ljs-2002/C-call-graph-producer)

通过cflow，tree2dotx，graphviz创建c语言文件的函数调用关系图，并集成为一条命令

tree2dotx.sh 转自[CSDN-cflow——C语言函数调用关系生成器](https://blog.csdn.net/lyndon_li/article/details/122163468)

*等待添加功能：检查文件是否存在、不显示某一函数/系统函数、自动识别类型*

## 目录

- [C-call-graph-producer](#c-call-graph-producer)
  - [目录](#目录)
  - [使用方法](#使用方法)
  - [使用示例](#使用示例)

## 使用方法

**带星号(\*)的是默认选项**

```
cgraph [-a <NUM>] [-d <NUM>] [-e <NUM>] [-r <NUM>] [-f <file1 file2...>] [-m <MODE>] [-T <TYPE>] [-o <NAME>] [-h]
```

***-a [NUM] :***
    
| **NUM** | **function** |
| ------- | ------- |
|     **0**    |    **Produce graphs only for main function(\*)**   |
|     1    |    Produce graphs for all global functions    |
|     2    |    Produce graphs for all functions    |

  
***-d [NUM] :***
  
           Set the depth at which the flow graph is cut of
  
***-e [NUM] :***

| **NUM** | **function** |
| ------- | ------- |
|     0    |    Disable display file name where the function is located     |
|     **1**    |    **Enable display file name where the function is located(\*)**    |

  
***-r [NUM] :***

| **NUM** | **function** |
| ------- | ------- |
|     0    |    Disable output in the order in which the functions appear     |
|     **1**    |    **Enable output in the order in which the functions appear(\*)**    |
     
***-f [filename]:***

           The files you want to produce call graph, default: all .c file in the folder
           use "filename1 filename2" to set multiple files as input
***-m [MODE] :***

| **MODE** | **description** |
| ------- | ------- |
|     **dot**    |    **Digraph (layering)(\*)**     |
|      neato   |    Based on spring-model    |
|     twopi    |    Radial layout    |
|     circo   |    Circle layout    |
|   fdp   |   Undigraph   |
|   patchwork   |   Square tree   |
           
***-T [TYPE] :***

| **TYPE** | **function** |
| ------- | ------- |
|     **jpg**    |    **Output .jpg file(\*)**     |
|     png    |    Output .png file    |
|     gif    |    Output .gif file    |
|     svg    |    Output .svg file    |

     
***-o [FILENAME] :***

           output file name, default: a.out
           
***-h :***

     Get help infomation
 
## 使用示例

>创建一个包含 a.c和b.c中所有函数的，不按函数出现顺序输出的，显示函数所在文件名的函数调用图，输出为test.svg
```
cgraph -a 2 -r 0 -T svg -o test.svg
```
