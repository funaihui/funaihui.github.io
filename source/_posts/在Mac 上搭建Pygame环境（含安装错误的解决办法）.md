---
title: 在Mac 上搭建Pygame环境（含安装错误的解决办法）
date: 2018-07-21 10:31:30
tags:
- Mac 
- Pygame 
- Python
categories: 
- Python
---

> 前言：说一下写本文的原因吧，最近在学习Python，学习到用pygame开发游戏的时候，在Mac电脑上装pygame却始终无法安装成功。折腾了好久才安装成功，因此准备记录一下安装方法，可以让想学习pygame开发游戏的人，不把时间浪费在装pygame上。

<!-- more -->

## 安装环境

&emsp;&emsp;说一下本文的内容是基于什么环境的，以免误导大家

- macOS：版本10.13.6
- Python:版本3.6.6 

## 开始安装

&emsp;&emsp;要安装Pygame依赖的包，需要先安装Homebrew，如果你还没有安装Homebrew，请自行查找安装。

1. 安装Pygame所依赖的库

   > $ brew install hg sdl sdl_image sdl_ttf

2. 如果要启用Pygame的更高级功能，如游戏中包含声音，还需要安装以下库

   > $ brew install sdl_mixer portmidi

3. 安装Pygame

   这部分内容有点多，放在下面小节讲

### 安装Pygame

&emsp;&emsp;可以用以下命令安装Pygame,如果是Python3把`pip`换成`pip3`即可

```
pip install pygame
```

如果出现以下界面则说明安装成功

![](https://user-gold-cdn.xitu.io/2018/7/21/164ba8edad831321?w=1408&h=200&f=png&s=131157)

<font color = 'red'>注：</font>这里说下我踩的坑，我是按照一本书上面安装进行安装的，书上的安装命令如下

```
pip3 install --user hg+http://bitbucket.org/pygame/pygame
```

安装之后的报错如下
![](https://user-gold-cdn.xitu.io/2018/7/21/164ba9ce0dd62a25?w=1406&h=1120&f=png&s=995860)

解决办法就是换安装命令。

## 结束语

&emsp;&emsp;其实，写本文的目的并不是解决上面那一个问题，在我安装Pygame的时候，用`pip install pygame`依然出现了问题，本文主要想写的就是用`pip install pygame`安装出错的解决办法，不过在写本文的时候，试了一下`pip install pygame`竟然一次就安装成功了。

&emsp;&emsp;如果你在安装时遇到什么问题，可以在文章下方留言，我会尽力为你解决。
