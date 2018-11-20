---
title: 在Linux（deepin）系统中搭建Android开发环境
date: 2017-02-16 15:57:49
tags: 
- Android 
- linux 
- AndroidStudio
categories: 
- Android
---
> 前言：尝试了一下在Linux系统中搭建Android开发环境，搭建过程真是一把心酸泪呀，在这里就把搭建的步骤与遇到的问题记录下来分享给大家，希望大家以后不要踩我踩过的坑。

<!-- more -->
## 配置JDK开发环境 ##

1. 下载JDK压缩包<br>
&emsp;&emsp;大家可以在ORACL官网下载系统需要的jdk压缩包[jdk压缩包](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)，这里以下载的后缀为.tar.gz的格式进行讲解。
2. 新建jvm文件夹<br>
&emsp;&emsp;在终端输入以下命令，即在/usr/lib/jvm路径下新建了一个jvm的文件夹。
```
sudo mkdir /usr/lib/jvm
```
3. 解压jdk压缩包<br>
&emsp;&emsp;使用以下命令将下载的jdk压缩包解压到刚才新建的jvm文件夹中。
```
//jdk-8u71-linux-i586.tar.gz换成自己的压缩包
sudo tar -zxvf jdk-8u71-linux-i586.tar.gz -C /usr/lib/jvm/
```
4. 配置jdk环境变量<br>
 &emsp;&emsp; 在终端中使用以下命令，打开profile文件
```
sudo gedit /etc/profile
```
<font size = 4 color = "red">注：</font>这时profile文件所有者是root用户为只读的，可以使用以下命令更改文件的所有者，更改所有者之后，文件就变成可读写的了。
```
sudo chown username /etc/profile
```
在profile文件末尾添加以下代码
```
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_71   
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH
```
然后保存就可以了，保存之后用以下命令初始化profile文件
```
source /etc/profile
```
5. 查看jdk环境是否配置成功<br>
&emsp;&emsp; 在终端输入 java -version 命令，如出现以下界面，则配置成功。 
![环境变量图片](http://img.blog.csdn.net/20170226204432406?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
## 配置Android Studio运行环境 ##
### 安装SDK Tools ###
- 下载SDK Tools<br>
&emsp;&emsp; 我们可以从这个网站下载SDK Tools，[http://www.androiddevtools.cn/](http://www.androiddevtools.cn/) ，如下，我们选择Linux版本的进行下载
![这里写图片描述](http://img.blog.csdn.net/20170226210855185?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
- 解压压缩包<br>
&emsp;&emsp; 使用以下命令将下载的压缩包解压到指定文件夹，这里我将压缩包解压到了这个路径下*/home/user/Android/*
```
sudo tar -zxvf android-sdk_r24.4.1-linux.tgz -C /home/user/Android/
```
- 打开Android SDK下载需要的文件
&emsp;&emsp; 通过以下命令进入tools目录下
```
cd /home/user/Android/android-sdk-linux/tools
```
通过以下命令进入打开android sdk
```
./android
```
图形界面如下
![sdk](http://img.blog.csdn.net/20170226212540316?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

 然后你就可以下载android开发需要的文件了。

### 下载Android Studio ###
&emsp;&emsp; 同样，我们可以从这个网站下载Android Studio：[http://www.androiddevtools.cn/](http://www.androiddevtools.cn/)，一个对安卓开发者很有用的网站。
### 配置Android Studio ###
1. 解压下载的Android Studio压缩包
```
sudo unzip 压缩包的名字
```
2. 运行Android Studio<br>
&emsp;&emsp; 通过以下命令进入解压后文件的bin目录下，这里我将Android Studio解压到了这个路径下*/home/user/Android*
```
cd /home/user/Android/android-studio/bin
```
通过以下命令，打开Android Studio
```
./studio
```
文章写到这里，安卓开发环境就已经搭建好了，但本文还没结束，下面就是讲解以下环境搭建好之后常见的问题。
## 常见问题解决 ##
### finished with non-zero exit value 2错误 
&emsp;&emsp; 错误如下图
![错误一](http://img.blog.csdn.net/20170226214845426?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
### 解决方法 ###
&emsp;&emsp;通过*File-->Project Structure*打开Project Structure设置界面，将JDK Location路径改为刚才安装JDK的路径即可，如图
![解决错误一](http://img.blog.csdn.net/20170226215541392?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### 使用platform -tools文件夹下的adb命令时提示二进制文件错误 ###
&emsp;&emsp; 这个错误难为了我好久，我还以为是系统的问题，结果换了一个系统结果还是一样报错，当时差点崩溃了，最后我自己下了下个platform -tools压缩包解压之后替换用sdk tools 下载的platform -tools，再次执行adb命令，终于成功了。
### 解决方法 ###
&emsp;&emsp; 自己下载platform -tools替换用sdk tools下载的platform -tools，下载platform -tools可以在这里下载：[http://www.androiddevtools.cn/](http://www.androiddevtools.cn/) 
<font size = 4 color = "red">注：</font>如果不解决这个问题，在用android  studio 连接真机调试是连接不上的。
### 问题：连接真机时不能识别真机 ###
![不能识别真机](http://img.blog.csdn.net/20170227114713222?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
### 解决方法###
1. 进入这个目录下/etc/udev/rules.d，我们会发现有个<font color="green">51-android-rules</font>文件，我们要做的就是在这个文件中添加自己的手机。
![这里写图片描述](http://img.blog.csdn.net/20170227115330185?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
你的可能不是51-android-rules文件，只要是xx-android-rules就行。<br>
2. 查找android手机ID
插入连接有android手机的usb数据线，在终端输入lsusb，找出手机的ID
![找出手机的ID](http://img.blog.csdn.net/20170227115745392?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

3. 在步骤1 规则文件中添加手机ID<br>
&emsp;&emsp;打开51-android.rules文件，添加以下信息
```
SUBSYSTEM=="usb",SYSFS{idVendor}=="12d1", MODE="0666"
```
将12d1改为你自己的手机ID，然后保存。
4. 重启udev服务<br>
&emsp;&emsp;在终端输入
```
sudo /etc/init.d/udev restart
```
5. 重启adb<br>
&emsp;&emsp; 用以下命令结束adb进程
```
sudo ./adb kill-server
```
重启进程
```
sudo ./adb devices 
```
然后就能识别你的手机了。
## 结束语
&emsp;&emsp; 以上就是在Linux（deepin）系统上搭建安卓开发环境的总结，虽然花费了一些时间，但也学到了好多，写这篇文章希望对大家有所帮助，节约一些不必要的时间.
><font  size = 5 color = "green">转载请注明出处：[www.wizardev.cn](http://www.wizardev.cn)<font>


