---
title: 反编译之将脱壳后的dex文件重新打包成apk
date: 2018-11-24 14:14:36
tags:
---

> 前言：通过上一篇文章[反编译之脱去乐固加固的壳](http://wizardev.cn/反编译之脱去乐固加固的壳.html)，已经可以拿到dex文件了，那么我们怎么将dex文件重新打包回新的apk呢？如果有这样的疑问，就看看这篇文章吧！一定会帮到你的！

### 得到dex文件之后该做什么？

&emsp;&emsp;说实话在我刚得到脱壳后的dex的文件的时候，有点懵，我在想拿到这个dex文件之后该做什么呢？怎么将这个真正的dex文件重新打包回apk呢？我们都知道没有加固的app反编译之后，源码是smali文件,但现在我拿到的是dex文件，所以在拿到dex文件之后，我们要做的就是将dex文件编译成smali文件，然后重新编译成apk。

### 将dex文件编译成smali文件

&emsp;&emsp;将dex文件编译成smali文件，我们需要下载[baksmali.jar文件](https://bitbucket.org/JesusFreke/smali/downloads/)，下载baksmali.jar文件之后，就可以通过以下命令将dex文件编译成smali文件了：

```
java -jar baksmali.jar smaliTest.dex
```

如：你要编译的dex文件是`testSmali.dex`则输入烦人命令是

```
java -jar basksmali.jar testSmali.dex
```

如果编译成功，此时会生成一个out目录，out目录里面的文件就是smali文件了。有时可能会遇到下面的错误

> Exception in thread "main" com.beust.jcommander.MissingCommandException: Expected a command, got classes.dexat com.beust.jcommander.JCommander.parseValues(JCommander.java:725)at com.beust.jcommander.JCommander.parse(JCommander.java:304)at com.beust.jcommander.JCommander.parse(JCommander.java:287)at org.jf.baksmali.Main.main(Main.java:90)

这时你只要将上面的命令换成

```
java -jar basksmali.jar disassemble testSmali.dex
```

即可解决。

### 回编译的注意事项

&emsp;&emsp;回编译经过加固后的app，还需要修改`AndroidManifest.xml`文件，具体的修改内容如下

![](https://user-gold-cdn.xitu.io/2018/11/24/1674493bec294f3e?w=2058&h=1010&f=png&s=460141)

需要将`android:name="xxx"`里面"xxx"的内容换成`android:value="yyy"`里面的"yyy",同时需要删除<meta-data>那行。