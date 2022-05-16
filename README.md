# C-call-graph-producer
通过cflow，tree2dotx，graphviz创建c语言文件的函数调用关系图，并集成为一条命令

tree2dotx.sh 转自https://blog.csdn.net/lyndon_li/article/details/122163468

*等待添加功能：检查文件是否存在*

## 使用方法

**带星号(\*)的是默认选项**

```
cgraph [-a <NUM>] [-d <NUM>] [-e <NUM>] [-r <NUM>] [-f <file1 file2...>] [-T <TYPE>] [-o <NAME>] [-h]
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
     
***-f (filename1   filename 2...) :***

           The files you want to produce call graph, default: all .c file in the folder
           
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
 
 
