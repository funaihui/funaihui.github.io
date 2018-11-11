---
title: Android自定义View之定点写文字
date: 2018-07-31 09:59:49
tags:
- Android 
- 自定义View
- View 
categories: 
- Android
---

> 前言：有经验的Android开发者，应该都会遇到在自定义View的时候，在View的某个地方写文字，那么当你在自定义的View中写文字的时候，能够做到定点写文字吗？能够指哪写哪吗？写出来的文字的位置和自己想要的位置一样吗？即使你最后写的文字的位置和自己想象的位置是一样的，那么你知道其中的原理吗？如果其中有一个你不能回答出来，那就认真的阅读本文吧！本文会给出你想要的答案...

<!-- more -->

## 一个小例子

&emsp;&emsp;看下下面的图，假如下面的图是我们要做出的效果

![](https://user-gold-cdn.xitu.io/2018/7/28/164e01409c028aad?w=610&h=462&f=png&s=15715)

很简单，有没有？就是在一个圆的中心写文字。红色的圆形很好画出来，那么我们怎么将文字写在圆的中心点上呢？第一时间想到的是拿到圆中心点的坐标，然后直接调用`drawText()`方法来写文字。实现的代码大致如下

```java
  @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        int measuredHeight = getMeasuredHeight();
        int measuredWidth = getMeasuredWidth();

        //cx,cy为圆的中心点的坐标
        int cx = measuredWidth / 2;
        int cy = measuredHeight / 2;
        canvas.drawCircle(cx, cy, mRadius, mPaint);
        mPaint.setTextSize(getResources().getDimensionPixelSize(R.dimen.sp18));
        mPaint.setColor(Color.WHITE);
        mPaint.setTextAlign(Paint.Align.CENTER);
        mPaint.setStrokeWidth(getResources().getDimensionPixelSize(R.dimen.dp1));
        canvas.drawText("wizardev", cx, cy, mPaint);
        
    }
```

现在，看下上面代码实现的效果

![](https://user-gold-cdn.xitu.io/2018/7/28/164e01ebecd769ea?w=634&h=368&f=png&s=14506)

上图中的黄线是在圆的中心点画的线，可以发现上面代码实现的效果，明显不是我们想要的效果，为什么会这样呢？下文会给出答案。

## drawText()中的基线

&emsp;&emsp;在Android中自定义View的时候，怎么让系统知道应该在哪里画出我们想要的图形呢？比如画上面的圆，这时我们就要告诉系统，我们要画的圆形的圆心在什么位置，告诉系统我们想要的圆的半径是多少，然后系统就能在合适的位置画出你想要的圆了。同样，在画文字的时候我们要指定文字在什么位置，而指定的坐标的位置就是文字的基线。

&emsp;&emsp;要理解`drawText()`中的基线是什么，需要先了解一下`darwText()`方法，`darwText()`方法有四个参数，如下

```java
drawText(@NonNull String text, float x, float y, @NonNull Paint paint)
```

第一个参数为你想要写的内容，第二个参数为文字开始的X轴坐标，第三个参数为文字开始的Y轴坐标，第四个参数为画笔。以第二个第三个参数画的一条水平线，就是`drawText()`的基线。如上文中的第二张图，黄色的线即为`drawText()`基线，

<font color='red'>注：</font>第二和第三个参数不一定为文字开始的坐标，也可能为文字中心的坐标或则文字结尾的坐标，具体是哪种坐标与`Paint`中的`setTextAlign()`方法有关。

&emsp;&emsp;可以得出结论，只要确定了基线的位置就确定了要画的文字的位置了。那么给定一个坐标，怎么确定基线的位置呢？其实画文字的时候，除了基线以外，还有其他几条线，其他几条线的位置如下图

![](https://user-gold-cdn.xitu.io/2018/7/30/164ea06f94d4f6ca?w=560&h=440&f=jpeg&s=27109)

这几条线的意义分别是：

- ascent: 系统建议的，字符所占的最高高度所在线
- descent:系统建议的，字符所占的最低高度所在线
- top: 可绘制的最高高度所在线
- bottom: 可绘制的最低高度所在线

这几条线的位置可以通过`FontMetrics`对象获得。

## FontMetrics

### (1)FontMetrics概述

&emsp;&emsp;描述给定文本的各种度量值的类，它有五个成员变量，分别为`top`、`ascent`、`descent`、`bottom`、`leading`。这几个成员变量的值都是相对基线位置的距离，如：

FontMetrics.top = top的Y坐标 - 基线

### (2)获取FontMetrics对象

想要获取FontMetrics，可以通过`getFontMetrics()`方法获取,具体代码如下

```java
Paint mPaint = new Paint()
mPaint.setTextSize(getResources().getDimensionPixelSize(R.dimen.sp18));
mPaint.setColor(Color.WHITE);
mPaint.setTextAlign(Paint.Align.CENTER);
mPaint.setStrokeWidth(1);
Paint.FontMetrics fontMetrics = mPaint.getFontMetrics();
```

### (3)FontMetrics注意事项

&emsp;&emsp;使用FontMetrics获取到的`top`、`ascent`、`descent`、`bottom`、`leading`成员变量的值，是相对于基线的距离，并不是坐标，可以看下下图，方便理解

![](https://user-gold-cdn.xitu.io/2018/7/30/164ea3e7c56e82e5?w=297&h=94&f=png&s=12783)

可以发现`top`、`ascent`的值为负数，`descent`、`bottom`的值为正数，为什么会这样呢？因为`top`线和ascent线在基线的上方，`FontMetrics`对象中的几个成员变量的值都是表示相对基线的位置。

## 指定位置写文字

&emsp;&emsp;了解了`FontMetrics`再结合下图

![](https://user-gold-cdn.xitu.io/2018/7/30/164ea06f94d4f6ca?w=560&h=440&f=jpeg&s=27109)

可以得到下面的公式：

- top的Y坐标 = 基线 + fontMetrics.top
- ascent的Y坐标 = 基线 + fontMetrics.ascent
- decent的Y坐标 = 基线 + fontMetrics.descent
- bottom的Y坐标 = 基线 + fontMetrics.bottom

### (1)给定左上方点写字

![](https://user-gold-cdn.xitu.io/2018/7/30/164ea586aa8c82c2?w=346&h=276&f=png&s=17743)

根据得出的公式可以计算出基线的Y坐标

> top的Y坐标 = 基线 + fontMetrics.top
>
> 基线 = top的Y坐标 -  fontMetrics.top

实现的代码如下

```java
Paint mPaint = new Paint();
mPaint.setTextSize(getResources().getDimensionPixelSize(R.dimen.sp18));
mPaint.setStrokeWidth(1);
mPaint.setColor(Color.RED);
Paint.FontMetrics fontMetrics = mPaint.getFontMetrics();
float baseLine = cy-fontMetrics.top;//cy指定点的Y坐标
canvas.drawText("wizardev", 0, baseLine, mPaint);

```

### (2)给定中间线写文字

![](https://user-gold-cdn.xitu.io/2018/7/30/164eaf9cbdc854b5?w=340&h=285&f=png&s=11595)

给定中间线写文字，可以说是自定义view写文字时用的最多的了，如，将文字写在圆的正中间，如上图，圆的中心线将文字平分，这种就是本文说的给定中间线写文字。文章前面说了，只要确定了基线的位置，文字的位置也就确定了，那么像这种，怎样来确定基线的位置呢？这时我们可以借助其他的几条线来计算出基线的位置。

![](https://user-gold-cdn.xitu.io/2018/7/30/164eb007f75f2c4a?w=412&h=404&f=png&s=20092)

如上图，将`top`和`center`之间的间距设为`A`,将`center`和`baseline`之间的距离设为`B`,将`center`和`bottom`之间的距离设为`C`。这是就可以得出下面的公式

> A = C = (bottom - top)/2
>
> B = baseline - center
>
> B = C - (bottom - baseline )

然后根据上文得到的公式:

> bottom = fontMetrics.bottom + baseline
>
> top  = fontMetrics.top + baseline

可以将最上面的公式修改为：

> baseline - center = (fontMetrics.bottom + baseline - fontMetrics.top - baseline) / 2 - (fontMetrics.bottom + baseline - baseline)

最后的到的公式为：

> baseline = center - (fontMetrics.bottom - fontMetrics.top) / 2 + fontMetrics.bottom

上面的到的公式就是给出中心线的位置，最后计算出的基线所在位置的公式。

### (3)给定底部线线文字

&emsp;&emsp;这种情况应该是最简单的了，直接把给定点的Y坐标作为基线的Y坐标就行了。

## 结束语

&emsp;&emsp;文章到这里，已经回答了文章开始的几个问题，相信阅读本文之后，你也对自定义View中画文字有了更清晰的理解。如果仍有什么疑问，可以在文章下方留言。

