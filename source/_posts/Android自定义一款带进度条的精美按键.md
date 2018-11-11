---
title: Android自定义一款带进度条的精美按键
date: 2017-08-27 10:35:04
tags:
- 自定义
- Android
- 精度条
- 按键
categories: 
- Android
---
[![](https://badge.juejin.im/entry/59a26ba851882524424a0e7b/likes.svg?style=flat-square)](https://juejin.im/entry/59a26ba851882524424a0e7b/detail)
> Android中自定义View并没有什么可怕的，拿到一个需要自定义的View，首先要做的就是把它肢解，然后思考每一步是怎样实现的，按分析的步骤一步一步的编码实现，最后你就会发现达到了你想要的效果。本文就按这样的步骤带你打造一款精美的按钮。

<!-- more -->
# 效果预览
&emsp;&emsp;在开始本文之前，照例，先看下实现后的效果，如下图
<center>![](http://ot6991tvl.bkt.clouddn.com/anim1.gif)</center>
不想阅读本文，可以直接到[这里获取源码](https://github.com/funaihui/ImitateKeepButton)

阅读本文你需要掌握
> 自定义属性<br> ValueAnimator动画<br>Viwe的测量、绘制<br>Paint和Path的用法


# 动手实现
## 拆解
&emsp;&emsp;在动手编码之前，要静下心来分析一下，这款View是怎样组成的，也就是要把这个View拆解一下。分析后，不难发现主要有一下部分组成
- 圆形背景
- 圆环的背景
- 圆环
- 文字

知道这个View是怎样组成的，然后完成相应部分的编码，最后将这些部分按时间顺序进行拼装展示，就能达到文章开头那样的效果了。
## 分析原理
&emsp;&emsp;经过拆解，知道了这个View都有那几部分组成了，下面就来分析一下是怎样将以上部分进行整合的
1. 在没点击之前，是一个中间带有文字的圆形。
2. 点击之后圆形缩小，当缩小到一定程度后，圆环背景出现，同时，圆环进度条开始加载。
3. 如果进度条加载完成，则改变文字（回调接口），抬起手后恢复原来的形状；如果没有加载完成，抬起手后，恢复原装，下次点击从新执行此步骤。

为了理解清楚，可以自己画一下流程图。
## 编码实现
&emsp;&emsp;相信，经过分析拆解之后，你脑子里应该有一个实现的流程了，下面就动手开始实现吧！

先将需要的画笔和路径进行初始化
```
 //初始化画笔及路径
    private void initPaintOrPath() {
        circleBgPaint = new Paint();
        circleBgPaint.setAntiAlias(true);
        circleBgPaint.setStyle(Paint.Style.FILL_AND_STROKE);

        ringBgPaint = new Paint();

        ringBgPaint.setColor(ringBgColor.getColorForState(getDrawableState(),0));
        ringBgPaint.setAntiAlias(true);
        ringBgPaint.setStrokeWidth(ringSize);
        ringBgPaint.setStyle(Paint.Style.STROKE);

        ringPaint = new Paint();
        ringPaint.setColor(ringColor.getColorForState(getDrawableState(),0));
        ringPaint.setAntiAlias(true);
        ringPaint.setStrokeWidth(ringSize);
        ringPaint.setStyle(Paint.Style.STROKE);

        path = new Path();

        textPaint = new Paint();
        textPaint.setAntiAlias(true);
        textPaint.setTextAlign(Paint.Align.CENTER);
        textPaint.setColor(textColor.getColorForState(getDrawableState(),0));
        textPaint.setTextSize(textSize);

    }
```
自定义View需要经过三个重要的步骤，***测量***，***布局***，***绘制***，分别对应***onMeasure()***,***onLayout()***,***onDraw()***方法。这里的***onLayout()***主要是对自定义ViewGroup的，自定义View只要重写***onMeasure()***和***onDraw()***方法就行了，按照自定义View的套路来，先进行测量，直接看代码
```
@Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        //获得父View传递过来的宽度的大小和类型
        int widthMode = MeasureSpec.getMode(widthMeasureSpec);
        int widthSize = MeasureSpec.getSize(widthMeasureSpec);
		//获得父View传递过来的高度的大小和类型
        int heightMode = MeasureSpec.getMode(heightMeasureSpec);
        int heightSize = MeasureSpec.getSize(heightMeasureSpec);
        //初始化最终的宽高
        int resultWidth = widthSize;
        int resultHeight = heightSize;
        //为了让文字可以在背景（圆形）中完全显示
        if (mRadius * 2 < textPaint.measureText(contentText)) {
            mRadius = (int) textPaint.measureText(contentText);
        }
        if (widthMode == MeasureSpec.AT_MOST) {
       	 //获取我们需要的宽度
            int contentWidth =  (mRadius + space + ringSize)*2+ getPaddingLeft() + getPaddingRight();
        //得到最终的宽度
            resultWidth = (contentWidth < widthSize) ? resultWidth : contentWidth;
        }

        if (heightMode == MeasureSpec.AT_MOST) {
         //获取我们需要的高度
            int contentHeight = (mRadius + space + ringSize)*2 + getPaddingTop() + getPaddingBottom();
            //得到最终的高度
            resultHeight = (contentHeight < heightSize) ? resultHeight : contentHeight;
        }
		//设置测量后的宽高
        setMeasuredDimension(resultWidth,resultHeight);
    }
```
代码中都有注释，相信你可以看的懂。下面就开始画我们需要的圆形，圆环背景，圆环和文字了，我们需要在onDraw()方法中进行作画，代码如下
```
 @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        //画圆，改变ringRadius就可以改变圆形背景的大小，主要控制value值的改变
        ringRadius = mRadius - DPUtils.dip2px(getContext(),value/2);
        circleBgPaint.setColor(circleColor.getColorForState(getDrawableState(),0));
        canvas.drawCircle(getWidth() / 2, getHeight() / 2, ringRadius, circleBgPaint);
        //用户按键时开始画圆环
        if (startDrawLine){
            //计算外环的半径，记得要减去外环的宽度的一半
            result = ringRadius + space +ringSize/2;
            //画完整的进度条
            canvas.drawCircle(getWidth() / 2, getHeight() / 2, result, ringBgPaint);
           //画进度条路径
            path.reset();//重置路径，否则下次精度条不会从开始位置，可以注释掉此代码，看下效果
            //计算画路径的矩形
            float left = getWidth()/2-result;
            float top = getHeight()/2-result;
            float right = getWidth()/2+result;
            float bottom = getHeight()/2+result;
            RectF rect = new RectF(left,top, right ,bottom);
            path.addArc(rect, -90, angle);//通过改变angle就可以动态的改变进度条

            //画圆环的路径
            canvas.drawPath(path, ringPaint);
        }
        canvas.drawText(contentText,getWidth()/2,getHeight()/2,textPaint);//文字
    }

```
完成以上几步，点击view时并没有反应，因为还没有为View添加触摸事件，也没有添加动画，进过分析原理那步，可以知道，手指按下时改变圆形背景的大小，既改变半径的大小......，这里就不在重复说了，直接看代码，代码中会有讲解
```
@Override
    public boolean onTouchEvent(final MotionEvent event) {
    //控制加载完成时候是否还可以相应点击事件，可以通过setEnable()方法来控制
        if (!enable && event.getAction()!=MotionEvent.ACTION_UP) {
            return false;
        }
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN: {
					//当手指按下时，移除手指抬起时的监听
                    if (animator != null) {
                        animator.removeAllUpdateListeners();
                    }
                    //改变narrowDown的值
                    animatorValue = ValueAnimator.ofInt(0, narrowDown);
                    animatorValue.setDuration(50);
                    animatorValue.setInterpolator(new LinearInterpolator());
                    animatorValue.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                        @Override
                        public void onAnimationUpdate(ValueAnimator valueAnimator) {						
                            value = (int) valueAnimator.getAnimatedValue();//改变value的值也就是按下手指让圆形背景缩小
                            if (value == narrowDown) {
                            //当缩小到一定值时开始画圆环和精度条
                                startDrawLine = true;//控制什么时候开始画圆环和进度条
                                animatorValue.removeAllUpdateListeners();//当开始画进度条时移除改变背景大小的动画，既停止改变
                            }
                            postInvalidate();//刷新画布
                        }
                    });

                    animatorValue.start();//开始缩小
                    
                    angleAnimator = ValueAnimator.ofFloat(0, 360f);
                    angleAnimator.setDuration(2000);
                    angleAnimator.setInterpolator(new LinearInterpolator());
                    angleAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                        @Override
                        public void onAnimationUpdate(ValueAnimator valueAnimator) {
                            angle = (float) valueAnimator.getAnimatedValue();//angle用来画进度条，动态改变进度条加载的进度
                            if (angle == 360) {
                            	//加载完成移除动画，既进度条停止加载
                                angleAnimator.removeAllUpdateListeners();
                                //进度条加载完成后的回调
                                onViewClick.onFinish(ImitateKeepButton.this);

                            }
                            postInvalidate();
                        }
                    });
                    angleAnimator.start();//开始加载
            }

            break;
            case MotionEvent.ACTION_UP: {
                 angleAnimator.removeAllUpdateListeners();
       			 animatorValue.removeAllUpdateListeners();
        		 animator = ValueAnimator.ofInt(value,0);
        		 animator.setDuration(300);
       			 animator.setInterpolator(new LinearInterpolator());
       			 animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
           		 @Override
           		 public void onAnimationUpdate(ValueAnimator valueAnimator) {
              	  value = (int) valueAnimator.getAnimatedValue();
              	  postInvalidate();
            }
        });
        animator.start();//开始恢复背景原来的大小
            }
            startDrawLine = false;
            break;
        }
        return true;
    }

```
好了，到这里已经达到了文章开始时的效果，可以结束本文了。
# 结束语
&emsp;&emsp;文中代码，只是粘贴部分比较重要的，不完整，完整代码可以到[这里获取源码](https://github.com/funaihui/ImitateKeepButton)。
> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>
