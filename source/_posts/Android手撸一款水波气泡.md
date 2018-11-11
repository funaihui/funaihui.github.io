---
title: Android手撸一款水波气泡
date: 2018-06-16 18:03:52
tags:
- Android 
- 自定义view 
categories: 
- Android
---

> 前言：公司在做的一个项目，要求在地图上以水波气泡的形式来显示站点，并且气泡要有水波的动态效果。好吧！既然有这样的需求，那就手撸一款水波气泡吧！

<!-- more -->

## 效果图预览

&emsp;&emsp;最后完成的效果图如下

![](https://user-gold-cdn.xitu.io/2018/6/16/16406f418e34b13e?w=400&h=656&f=gif&s=79318)

不想看文章的话，可以[点击这里](https://github.com/funaihui/DropletBubbles)，直接获取源码。

## 实现方式

### 步骤拆解

&emsp;&emsp;在需要自定义view的时候，我首先要做的就是将最后要实现的效果来进行拆分，拆分成许多小的步骤，然后一步步的来实现，最终达到想要的效果。

&emsp;&emsp;可以将文章开始的时候的效果图拆分成以下几部分：

1. 画出气泡后面的白色背景。
2. 画内部的紫色气泡。
3. 用贝塞尔曲线让内部的紫色气泡动起来。

拆解之后，就可以按照拆解的步骤来一步步实现了。

### 画白色背景

&emsp;&emsp;这里画白色背景有以下两种方式：

1. 用`path`直接描述一个白色背景的形状。
2. 用`path`描述一个三角形，然后在画出一个圆形，即成最终的白色背景了。

第一种方式如下图的左图，用`path`直接描述出了白色背景，这种方式可以用`path.addArc()`来画上部弧形，然后用`path.moveTo()`和`path.lineTo()`方法描述出下部分的尖角。

第二种实现的方式如下图的右图，直接画出一个圆，再用`path.moveTo()`和`path.lineTo()`方法来描述出下部分的尖角。

![](https://user-gold-cdn.xitu.io/2018/6/16/1640756a199d4329?w=600&h=600&f=png&s=27427)

本文采用的是第二种方式来实现的，具体代码如下

```java
//此处代码是下部尖角的path
mBackgroundPath.moveTo(mResultWidth / 2 - mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2);
        mBackgroundPath.lineTo(mResultWidth / 2, mResultWidth / 2 + mOutRadius + mOutRadius / 4);
        mBackgroundPath.lineTo(mResultWidth / 2 + mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2);

 //画外部背景
        canvas.drawPath(mBackgroundPath, mBackgroundPaint);
        canvas.drawCircle(mResultWidth / 2, mResultWidth / 2, mOutRadius, mBackgroundPaint);
```

### 画内部的气泡

&emsp;&emsp;内部的气泡的形状其实就是缩小的外部背景，具体的代码如下

```java
 //内部气泡的尖角 
mBubblesPath.moveTo(mResultWidth / 2 - mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2 - dp2px(getContext(), 5));
        mBubblesPath.lineTo(mResultWidth / 2, mResultWidth / 2 + mOutRadius + mOutRadius / 4 - dp2px(getContext(), 5));
        mBubblesPath.lineTo(mResultWidth / 2 + mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2 - dp2px(getContext(), 5));
//画圆
 mBubblesPath.addCircle(mResultWidth / 2, mResultWidth / 2, mInnerRadius, Path.Direction.CCW);
```

到这里已经将气泡的基本形状画出来了，见下图

![](https://user-gold-cdn.xitu.io/2018/6/16/164077f14d652e62?w=806&h=1164&f=png&s=51955)

我们会发现气泡内部的颜色是渐变色，那渐变色是怎么设置的呢？其实自定义view就是将想要的效果通过画笔画在画布上，实现颜色的渐变肯定就是通过设置画笔的属性来实现的了，设置渐变色的代码如下

```java
 //设置渐变色
        Shader shader = new LinearGradient(mResultWidth / 2, mResultWidth / 2 - mInnerRadius, mResultWidth / 2, mResultWidth / 2 + mInnerRadius, Color.parseColor("#9592FB"),
                Color.parseColor("#3831D4"), Shader.TileMode.CLAMP);
        mBubblesPaint.setShader(shader);
```

> ` LinearGradient(float x0, float y0, float x1, float y1,        @ColorInt int color0, @ColorInt int color1,        @NonNull TileMode tile)` 
>
> `x0` `y0` `x1` `y1`：渐变的两个端点的位置  `color0` `color1` 是端点的颜色  `tile`：端点范围之外的着色规则，类型是 `TileMode`。`TileMode` 一共有 3 个值可选： `CLAMP`, `MIRROR`和 `REPEAT`。一般用 `CLAMP`就可以了。

### 让内部气泡动起来

&emsp;&emsp;气泡内部的动画是水波的形式，这里画水波用的是二阶贝塞尔曲线，关于Android中贝塞尔曲线的知识可以[参考这里](https://blog.csdn.net/harvic880925/article/details/50995587)。实现气泡内部水波效果的代码如下

```java
 /**
     * 核心代码，计算path
     *
     * @return
     */
    private Path getPath() {
        int itemWidth = waveWidth / 2;//半个波长
        Path mPath = new Path();
        mPath.moveTo(-itemWidth * 3, baseLine);//起始坐标
        Log.d(TAG, "getPath: " + baseLine);

        //核心的代码就是这里
        for (int i = -3; i < 2; i++) {
            int startX = i * itemWidth;
            mPath.quadTo(
                    startX + itemWidth / 2 + offset,//控制点的X,（起始点X + itemWidth/2 + offset)
                    getWaveHeight(i),//控制点的Y
                    startX + itemWidth + offset,//结束点的X
                    baseLine//结束点的Y
            );//只需要处理完半个波长，剩下的有for循环自已就添加了。
        }
        Log.d(TAG, "getPath: ");
        //下面这三句话是行程封闭的效果，不明白可以将下面3句代码注释看下效果的变化
        mPath.lineTo(width, height);
        mPath.lineTo(0, height);
        mPath.close();
        return mPath;
    }

//奇数峰值是正的，偶数峰值是负数
    private float getWaveHeight(int num) {
        if (num % 2 == 0) {
            return baseLine + waveHeight;
        }
        return baseLine - waveHeight;
    }
```

上面的代码画出的水波如下图

![](https://user-gold-cdn.xitu.io/2018/6/16/16407c543df386b4?w=1920&h=1334&f=jpeg&s=95534)

到这里已经画出了水波，但现在水波还是静止的，要让水波不停的移动，就要添加属性动画，添加动画的代码如下

```java
 /**
     * 不断的更新偏移量，并且循环。
     */
    public void updateXControl() {
        //设置一个波长的偏移
        ValueAnimator mAnimator = ValueAnimator.ofFloat(0, waveWidth);
        mAnimator.setInterpolator(new LinearInterpolator());
        mAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {

            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                float animatorValue = (float) animation.getAnimatedValue();
                offset = animatorValue;//不断的设置偏移量，并重画
                postInvalidate();
            }
        });
        mAnimator.setDuration(1800);
        mAnimator.setRepeatCount(ValueAnimator.INFINITE);
        mAnimator.start();

    }
```

修改一下`onDraw`中的代码，如下

```java
 @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        mBubblesPath.reset();

        //设置渐变色
        Shader shader = new LinearGradient(mResultWidth / 2, mResultWidth / 2 - mInnerRadius, mResultWidth / 2, mResultWidth / 2 + mInnerRadius, Color.parseColor("#9592FB"),
                Color.parseColor("#3831D4"), Shader.TileMode.CLAMP);
        mBubblesPaint.setShader(shader);

        //此处代码是下部尖角的path
        mBackgroundPath.moveTo(mResultWidth / 2 - mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2);
        mBackgroundPath.lineTo(mResultWidth / 2, mResultWidth / 2 + mOutRadius + mOutRadius / 4);
        mBackgroundPath.lineTo(mResultWidth / 2 + mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2);


        //内部气泡的尖角
        mBubblesPath.moveTo(mResultWidth / 2 - mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2 - dp2px(getContext(), 5));
        mBubblesPath.lineTo(mResultWidth / 2, mResultWidth / 2 + mOutRadius + mOutRadius / 4 - dp2px(getContext(), 5));
        mBubblesPath.lineTo(mResultWidth / 2 + mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2 - dp2px(getContext(), 5));
        //画外部背景
        canvas.drawPath(mBackgroundPath, mBackgroundPaint);
        canvas.drawCircle(mResultWidth / 2, mResultWidth / 2, mOutRadius, mBackgroundPaint);
        Log.d(TAG, "cx: " + mResultWidth / 2);
        //画水波
        mBubblesPath.addCircle(mResultWidth / 2, mResultWidth / 2, mInnerRadius, Path.Direction.CCW);

        canvas.drawPath(getPath(), mBubblesPaint);

    }
```

好了，现在水波已经可以移动了，看下效果

![](https://user-gold-cdn.xitu.io/2018/6/16/16407cbd1ccab2cc?w=400&h=297&f=gif&s=41681)

what！怎么成这个样子了呀,明显不是我想要的效果呀，肯定是哪里出错了，经过我仔细的推敲，总结了出现上面问题的原因，原因如下图

![](https://user-gold-cdn.xitu.io/2018/6/16/16407d4afe491a98?w=1920&h=1334&f=jpeg&s=129606)

出现上面问题的原因就是因为下面三句代码

```java
 mPath.lineTo(width, height);
 mPath.lineTo(0, height);
 mPath.close();
```

知道是这三句代码的原因，那应该怎么修改呢？这三句代码好像不能动，不然就会出现波浪画的不完整的情况，额.....,那应该修改哪里呢？灵光一闪，不是可以裁剪画布嘛，只要将画布裁剪成想要的形状，然后在画波浪不久完美了。再修改`onDraw`方法，修改后的代码如下

```java
  @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        mBubblesPath.reset();

        //设置渐变色
        Shader shader = new LinearGradient(mResultWidth / 2, mResultWidth / 2 - mInnerRadius, mResultWidth / 2, mResultWidth / 2 + mInnerRadius, Color.parseColor("#9592FB"),
                Color.parseColor("#3831D4"), Shader.TileMode.CLAMP);
        mBubblesPaint.setShader(shader);

        //此处代码是下部尖角的path
        mBackgroundPath.moveTo(mResultWidth / 2 - mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2);
        mBackgroundPath.lineTo(mResultWidth / 2, mResultWidth / 2 + mOutRadius + mOutRadius / 4);
        mBackgroundPath.lineTo(mResultWidth / 2 + mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2);


        //内部气泡的尖角
        mBubblesPath.moveTo(mResultWidth / 2 - mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2 - dp2px(getContext(), 5));
        mBubblesPath.lineTo(mResultWidth / 2, mResultWidth / 2 + mOutRadius + mOutRadius / 4 - dp2px(getContext(), 5));
        mBubblesPath.lineTo(mResultWidth / 2 + mOutRadius / 2, mResultWidth / 2 + mOutRadius / 2 - dp2px(getContext(), 5));
        //画外部背景
        canvas.drawPath(mBackgroundPath, mBackgroundPaint);
        canvas.drawCircle(mResultWidth / 2, mResultWidth / 2, mOutRadius, mBackgroundPaint);
        Log.d(TAG, "cx: " + mResultWidth / 2);
        //切割画布，画水波
        canvas.save();
        mBubblesPath.addCircle(mResultWidth / 2, mResultWidth / 2, mInnerRadius, Path.Direction.CCW);
        //将画布裁剪成内部气泡的样子
        canvas.clipPath(mBubblesPath);

        canvas.drawPath(getPath(), mBubblesPaint);
        canvas.restore();

    }
```

到这里已经实现了文章开始时的效果了，文章也该结束了。

## 结束语

&emsp;&emsp;本文主要是讲解怎样实现水波气泡，并没有讲到View的测量，贴出的也只是绘制气泡的代码，完整的代码可以[点击这里](https://github.com/funaihui/DropletBubbles)获取。

&emsp;&emsp;虽然已经撸出了这个效果，但最后项目中并没有用这种动态的气泡，因为气泡多的时候是在是卡……。最后，喜欢此demo，就随手给个star吧！
> **ps:** 历史文章中有干货哦！

> 本文已由公众号<font color=#d2691e size = 5>“AndroidShared”</font>首发
