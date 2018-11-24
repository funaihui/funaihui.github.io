---
title: Android轻松实现分享功能
date: 2017-08-20 17:09:06
tags: 
- Android
- 分享
- 图片
categories: 
- Android
---
<left>[![](https://badge.juejin.im/entry/599ae92151882524302845fb/likes.svg?style=flat-square)](https://juejin.im/entry/599ae92151882524302845fb/detail)</left>
> 在Android开发中，要实现分享功能，可能首先想到第三方的ShareSDK，其实，想要分享一些图片，文本之类的完全没必要在App中集成第三方SDK，利用原生的SDK就可以轻松实现分享功能。

<!-- more -->
# Activity的跳转方式
&emsp;&emsp;众所周知，Activity的跳转方式分为两种，分别为**显示跳转**和**隐式跳转**
## 显示跳转
&emsp;&emsp;显示跳转比较简单，直接看代码
```
Intent intent=new Intent(MainActivity.this, OtherActivity.class); 
startActivity(intent);
```
## 隐式跳转
&emsp;&emsp;隐式跳转复杂一点，同样，先看下代码
```
Intent shareIntent = new Intent();
shareIntent.setAction(Intent.ACTION_SEND);
shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
shareIntent.setType("image/jpeg");
startActivity(shareIntent);
```
可以看到隐式跳转Activity不像显示跳转那样，直接在Intent中设置类名进行跳转。隐式跳转的步骤如下

1. 实例化Intent。
2. 设置Action。
3. 设置Extra（可选）。
4. 设置类型（可选）
5. 通过startActivity启动相应的Activity。

步骤2中的setAction()，其中需要的参数是，你要跳转的目标Activity所设置的Action，设置Action可以在**AndroidManifest.xml**中进行设置。setAction()中的参数就是过滤条件，决定我们跳转到哪个Activity。同样，setType()中的参数也是过滤条件，如果说setAction()是一级过滤，那么setType()则是二级过滤，过滤的更加细致。putExtra()中的参数，就是跳转到目标Activity携带的参数。

&emsp;&emsp;了解过了Activity的跳转方式，下面就进入本文的重点，为软件实现分享功能。
# 实现分享功能
## 分享图片
&emsp;&emsp;由于需要调用系统的Activity，所以，我们只能选择Activity的隐式跳转方式，先看下实现分享图片的代码
```
public static void shareImage(Context context, Uri uri, String title) {
        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND);
        shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
        shareIntent.setType("image/jpeg");
        context.startActivity(Intent.createChooser(shareIntent, title));
    }
```
这里主要说一下其中的一些参数，**uri**就是你要分享的图片的路径，**title**就是分享时显示的文字，额...，为了不让大家误解，下面看一张图，图中红框标起来的就是**title**
<center>
![](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_014.png)</center>
再来看一下这个代码
```
Intent.createChooser(shareIntent, title)
```
官方文档的介绍如下
> Builds a new ACTION_CHOOSER Intent that wraps the given target intent, also optionally supplying a title. 

上面一段话的主要意思就是，就是为目标Activity提供一个标题。
## 分享文本
&emsp;&emsp;文本分享和图片分享大同小异，直接看代码
```
public static void shareText(Context context, String extraText) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("text/plain");
        intent.putExtra(Intent.EXTRA_SUBJECT, context.getString(R.string.action_share));
        intent.putExtra(Intent.EXTRA_TEXT, extraText);//extraText为文本的内容
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);//为Activity新建一个任务栈
        context.startActivity(
                Intent.createChooser(intent, context.getString(R.string.action_share)));//R.string.action_share同样是标题
    }
```
其中与分享图片不同的代码已经在代码中进行了注释。
# 实现可以被系统分享调用的App
&emsp;&emsp;以上实现了，通过系统调用其他的App进行分享，那么，我们怎样让自己的App可以被系统列入可以分享的App呢？
其实很简单，只要在**AndroidManifest.xml**中Activity的**action**标签设置以下值即可
```
android.intent.action.SEND
```
看下示例代码
```
<activity android:name=".ShareActivity">
            <intent-filter>
                <action android:name="android.intent.action.SEND"/>
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
```
这样，在系统调用可以用来分享的App时，我们的软件就会出现在列表中了。
# 结束语
> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.cn](http://www.wizardev.cn)<font>

