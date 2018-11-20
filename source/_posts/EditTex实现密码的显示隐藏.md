---
title: EditTex实现密码的显示隐藏
date: 2017-08-13 08:35:52
tags: 
- EditText 
- passWord 
- Android
categories: 
- Android
---
> 在开发app时，登录和注册页面，让输入的密码是否可见的需求还是挺常见的，本以为在代码中直接设置EditText的setInputType属性就行了，谁知还是有一些坑的，本篇文章带你来填坑，前方高能，请速速避退。

<!-- more -->
## 完成后的效果
&emsp;&emsp;在开始本文之前，先看下要实现的效果.
![](http://ot6991tvl.bkt.clouddn.com/anim.gif)
<center></center>
## 开始挖坑
### 查看EditText的setInputType可以设置的值
&emsp;&emsp;先看下EditText的setInputType可以设置的Type属性有多少
<center>![Type属性](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_010.png)</center>etInputType可以设置的Type属性值远不止这么多，全部的属性可以到[这里查看](https://developer.android.google.cn/reference/android/text/InputType.html).查看Type可以设置的值后，发现有两个Type与密码的显示和隐藏有关，分别是
> TYPE_TEXT_VARIATION_VISIBLE_PASSWORD 
> TYPE_TEXT_VARIATION_PASSWORD


根据单词的意思我们知道第一个为显示密码，第二个为密码不可见.
### 在代码中设置setInputType的值
&emsp;&emsp;根据查询的Type值便可以在代码中通过设置setInputType的值来让EditText输入的值显示隐藏.下面看下代码
```
 //根据图标判断是否显示密码
    private void whetherShowPas(boolean paswdVisible) {
        if (paswdVisible) {
            //设置密码为显示的状态
  mPassWd.setInputType(TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
            img_eye.setImageResource(R.mipmap.dis);
        } else {
            //设置密码为隐藏的状态
     mPassWd.setInputType(TYPE_TEXT_VARIATION_PASSWORD);
            img_eye.setImageResource(R.mipmap.hid);
        }
     mPassWd.setSelection(mPassWd.getText().length());//将光标定位到最后
    }
```
好了，到这里你以为就完成了，高高兴兴的跑去模拟器运行看效果，但悲催的是，切换这两个状态竟然没用，不能实现开篇时的效果.
## 填坑之路
&emsp;&emsp;于是，我们又来查官方文档，进入刚刚查看Type值的页面，咦，这里有个Example，如下图
<center>![](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_011.png)</center>
竟然，要再加入一个<font color = orange >TYPE_CLASS_TEXT</font>，好，我们把这个值加入刚才的代码，改变后的代码如下
```
 //根据图标判断是否显示密码
    private void whetherShowPas(boolean paswdVisible) {
        if (paswdVisible) {
            //设置密码为显示的状态
            mPassWd.setInputType(TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
            img_eye.setImageResource(R.mipmap.dis);
        } else {
            //设置密码为隐藏的状态
            mPassWd.setInputType(TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_PASSWORD);
            img_eye.setImageResource(R.mipmap.hid);
        }
    mPassWd.setSelection(mPassWd.getText().length());//将光标定位到最后
    }
```
在到模拟器运行一遍，WTF，果然达到了开篇时的效果，在看下<font color = orange >TYPE_CLASS_TEXT</font>有什么作用
>TYPE_CLASS_TEXT<br>
>Class for normal text

<font color = orange >TYPE_CLASS_TEXT</font>
就是将EditText转化为普通文本类，原来需要将EditText转换为普通文本类设置密码是否可见才能生效.
## 结束语
&emsp;&emsp;好了，到这里本文就结束了，可以在这里[获取本文的源码](https://github.com/funaihui/HideOrDissplayPSWD).
<font color=#d2691e size = 5>转载请注明出处：[www.wizardev.cn](http://www.wizardev.cn)<font>




