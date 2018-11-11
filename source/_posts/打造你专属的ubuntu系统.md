---
title: 打造你专属的ubuntu系统
date: 2017-11-02 20:59:29
tags: 
- linux Ubuntu
categories: 
- linux
---

> 前言：作为一名程序员重装系统是在所难免的，每次重装系统后都要安装一些必要的软件及进行一系列的环境配置，Windows倒还好，Linux上软件的安装及环境的配置都需要查找资料获取相应的命令，为了以后重装系统后不到处查找资料，就把一些常用的软件的安装命令及系统的配置命令记录下来。

<!-- more -->
<font color="red" size = "5">注：</font>本文软件的安装及环境的配置都是基于Ubuntu16.04的。

## 删除软件

### 删除libreoffice

```
sudo apt-get remove libreoffice-common 
```

### 删除Amazon的链接

```
sudo apt-get remove unity-webapps-common 
```

### 删除一些不常用的软件

```
sudo apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku
```

```
sudo apt-get remove onboard deja-dup
```

## 更新

&emsp;&emsp;通过以下命令便可以更新系统和软件

```
sudo apt-get update
sudo apt-get upgrade
```



## 主题美化

&emsp;&emsp;Ubuntu原生的主题真是不敢恭维，个人比较喜欢Mac的主题，这里就说一下怎样把主题变为Mac主题。

### 安装 MacUbuntu OS Theme、Icons 和 Cursors

```
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install macbuntu-os-icons-lts-v7
sudo apt-get install macbuntu-os-ithemes-lts-v7
```

### 安装Unity Tweak Tool 及启用主题

&emsp;&emsp;上面的命令是将主题下载到本地，可以通过Unity Tweak Tool进行主题的设置，下面是Unity Tweak Tool 的安装命令。

```
sudo apt-get install unity-tweak-tool 
```

通过以下命令打开软件

```
unity-tweak-tool
```

打开之后的界面如下

![界面](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_001.jpg)

然后，就可以设置下载过的主题了。

### 安装 Slingscold（替代Launchpad）



```
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install slingscold
```

Slingscold就是显示本地中已安装的软件

![slingscold](http://ot6991tvl.bkt.clouddn.com/%E6%AD%A5%E9%AA%A4.png)

### 安装 Plank Dock

```
sudo apt-get install plank
```

安装后通过一下命令启动

```
plank
```

启动后的界面如下

![plank](http://ot6991tvl.bkt.clouddn.com/plank.jpg)

安装之后并不是这样的，这里我们需要安装plank主题，安装plank主题的命令如下

```
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install macbuntu-os-plank-theme-lts-v7
```

安装之后，调出plank后按住ctrl键右击鼠标便可以调出菜单，再点击菜单中的首选项就能够更换plank的主题了。

### 设置plank为开机启动

&emsp;&emsp;每次手动启动plank太麻烦，设置开机启动就省了很多事，关于怎样设置开机启动可以看这里，[ubuntu16.04添加应用开机启动](https://jingyan.baidu.com/article/ce09321b63893c2bfe858f72.html)。下图是设置plank开机启动的命令

![设置plank开机启动](http://ot6991tvl.bkt.clouddn.com/plank.png)

### 修改状态栏“Ubuntu桌面”为“Mac OS X”

&emsp;&emsp;以下命令便可以将状态栏“Ubuntu桌面”设置为“Mac OS X”

```
cd && wget -O Mac.po http://drive.noobslab.com/data/Mac/change-name-on-panel/mac.po
cd /usr/share/locale/zh_CN/LC_MESSAGES
sudo msgfmt -o unity.mo ~/Mac.po;rm ~/Mac.po
```

如果系统用的不是中文，只需要将上述命令中的“zh_CN”换成其他语言就行了，如系统是英语，则将“zh_CN”换成“en”。

## 软件的安装

### 安装搜狗输入法

&emsp;&emsp;搜狗输入法有Linux版，可以到[官网下载](http://pinyin.sogou.com/linux/)，下载之后通过一下命令进行安装

```
sudo dpkg -i sogoupinyin_2.1.0.0086_amd64.deb
```

如果安装中要遇到缺少依赖的问题，可以通过一下命令添加依赖

```
sudo apt-get -f install
```

然后再次运行安装命令即可。

### 安装chrome或chromium

#### 安装chrome

```
sudo apt-get install libappindicator1 libindicator7  
sudo dpkg -i google-chrome-stable_current_amd64.deb   
sudo apt-get -f install  
```

#### 安装chromium

```
sudo add-apt-repository ppa:a-v-shkop/chromium
sudo apt-get update
sudo apt-get install chromium-browser
```

### 安装解压rar

&emsp;&emsp;Ubuntu上是不能直接解压rar文件的，需要安装unrar，以下是安装命令

```
sudo apt-get install unrar
```

### 安装wps

&emsp;&emsp;可以在[官网下载](http://community.wps.cn/download/)安装包，然后通过以下命令进行安装

```
sudo dpkg -i wps-office_10.1.0.5672~a21_amd64.deb 
```

同样，如果提示缺少依赖，运行一下命令

```
sudo apt-get -f install
```

然后再次安装。

#### 解决wps提示字体缺失问题

1. 下载字体文件：https://pan.baidu.com/s/1eS6xIzo。
2. 解压缩，定位倒解压后的文件夹运行以下命令。

```
sudo cp mtextra.ttf  symbol.ttf  WEBDINGS.TTF  wingding.ttf  WINGDNG2.ttf  WINGDNG3.ttf  /usr/share/fonts 
```

3. 成功解决字体缺失问题。

### 安装 shadowsocks-qt5

```
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5
```

### 安装markdown软件

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 
sudo add-apt-repository 'deb http://typora.io linux/'
sudo apt-get update
sudo apt-get install typora
```

### 安装为知笔记

```
sudo add-apt-repository ppa:wiznote-team 
sudo apt-get update 
sudo apt-get install wiznote
```

### 安装网易云音乐

&emsp;&emsp;[官网下载安装包](http://music.163.com/#/download)，安装方法同“安装搜狗输入法”。

## 结束语

&emsp;&emsp;这篇文章就先介绍这么多，以后可能还会继续补充，欢迎持续关注

> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>