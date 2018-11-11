---
title: 自己动手写RecyclerView的上拉加载
date: 2017-12-26 22:56:57
tags:
- Android
- RecyclerView 
- 上拉加载
categories: 
- Android
---

> 前言:上一篇文章[自己动手写RecyclerView的下拉刷新](https://juejin.im/post/5a22af7a6fb9a0450e75ee61)写过之后大家真是各种批评呀!耦合度高、考虑的情况单一什么的.....在这里说明一下,为了能够让更大家清楚的了解RecyclerView下拉刷新的这种原理,所以代码的耦合度就高了一些!本篇文章将会为大家讲解一下怎样实现RecyclerView的上拉加载,为了讲明白原理,文中代码的依然会紧耦合。

<!-- more -->

&emsp;&emsp;如果你阅读过[自己动手写RecyclerView的下拉刷新](https://juejin.im/post/5a22af7a6fb9a0450e75ee61)这篇文章，那么你也一定知道了怎样在RecyclerView中显示不同的布局了，本篇文章讲的主要内容有以下两点
1. 为RecyclerView添加FooterView作为加载更多时显示的视图。
2. 监听RecyclerView的滑动状态，根据不同的状态来改变FooterView的显示状态。

## 为RecyclerView添加加载更多时的视图
&emsp;&emsp;上篇讲过的知识这里就不再讲了，首先看下FooterView的布局文件，如下
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/loading_view"
    android:layout_width="match_parent"
    android:layout_height="@dimen/dp_60"
    android:gravity="center"
    android:orientation="vertical">

    <ViewStub
        android:id="@+id/loading_viewstub"
        android:layout_width="match_parent"
        android:layout_height="@dimen/dp_60"
        android:layout="@layout/layout_recyclerview_footer_loading" />

    <ViewStub
        android:id="@+id/end_viewstub"
        android:layout_width="match_parent"
        android:layout_height="@dimen/dp_60"
        android:layout="@layout/layout_recyclerview_footer_end" />

</LinearLayout>
```
这里为了节省内存资源,用了ViewStub,ViewStub是一个轻量级的View，它是一个看不见的，不占布局位置，占用资源非常小的控件。使用ViewStub可以方便的在运行时控制展示那个布局。
### 在Adapter中加载FooterView
&emsp;&emsp;在RecyclerView中加载不同的布局的方法，上篇已经讲解过了，这里就直接看关键的代码
```java
@Override
    public int getItemViewType(int position) {
        if (isFooter(position)) {
            return FOOTER_VIEW_TYPE;
        }
        return super.getItemViewType(position);
    }
    
    public boolean isFooter(int position) {
        int lastPosition = getItemCount() - getFooterViewCount();
        return getFooterViewCount() > 0 && position >= lastPosition;
    }
```
上面代码中**isFooter**方法就是判断在position这个位置的视图是否是FooterView。
## 控制FooterView的显示隐藏
&emsp;&emsp;文章上部分已经讲了怎样在RecyclerView中添加FooterView，下面就重点将下FooterView在什么时候隐藏和显示。我们肯定知道RecyclerView在正常的状态下FooterView也就是底部刷新的视图是不可见的，在我们下滑到RecyclerView的最后一个条目时才显示底部刷新的视图，同时，在RecyclerView没有将屏幕铺满时不会显示底部刷新的视图。把这句话整理一下就是下面三点
1. RecyclerView在正常状态下，底部刷新的视图不可见。
2. 在滑动RecyclerView时，最后一个可见的item大于或等于RecyclerView总的条目数时，显示底部刷新的视图。
3. 当RecyclerView的条目数未占满屏幕时，不会显示底部刷新视图。

好了，知道了什么时候显示和隐藏底部刷新的视图，下面面临的问题就是**我们怎样获取RecyclerView的最后一个可见的item的position**？我们知道RecyclerView总的条目数可以利用LayoutManager的getItemCount方法获取，那么LayoutManager中是否有获取最后一个可见的item的position的方法呢！答案是肯定的，我们可以通过LayoutManager中的方法获取最后一个可见的item的position，但是LayoutManager又有**LinearLayoutManager**、**GridLayoutManager**和**StaggeredGridLayoutManager**，怎样分别在这三个LayoutManager中获取最后一个可见的item的position呢，答案在以下代码中
```java
 LayoutManager layoutManager = getLayoutManager();//获取LayoutManager

        if (layoutManagerType == null) {
            if (layoutManager instanceof LinearLayoutManager) {
                layoutManagerType = LayoutManagerType.LinearLayout;
            } else if (layoutManager instanceof GridLayoutManager) {
                layoutManagerType = LayoutManagerType.GridLayout;
            } else if (layoutManager instanceof StaggeredGridLayoutManager) {
                layoutManagerType = LayoutManagerType.StaggeredGridLayout;
            } else {
                throw new RuntimeException("LayoutManager不符合规范!");
            }
        }

        switch (layoutManagerType) {
            case LinearLayout:
                mLastVisibleItemPosition = ((LinearLayoutManager) layoutManager).findLastVisibleItemPosition();
                break;
            case GridLayout:
                mLastVisibleItemPosition = ((GridLayoutManager) layoutManager).findLastVisibleItemPosition();
                break;
            case StaggeredGridLayout:
                StaggeredGridLayoutManager staggeredGridLayoutManager = (StaggeredGridLayoutManager) layoutManager;
                if (lastPositions == null) {
                    lastPositions = new int[staggeredGridLayoutManager.getSpanCount()];
                    staggeredGridLayoutManager.findLastVisibleItemPositions(lastPositions);
                }
                mLastVisibleItemPosition = findMax(lastPositions);
                break;
        }
```
看过代码之后，可以发现这里比较特殊的是**StaggeredGridLayoutManager**，由于它的特殊性，可能导致**LastVisibleItemPositions**有多个，这里的处理办法是将LastVisibleItemPositions放进数组中，然后取出数组中最大的数作为LastVisibleItemPosition。因为LastVisibleItemPosition根据滑动的位置而变化的，所以需要把上面的代码放进RecyclerView的onScrolled方法中。

&emsp;&emsp;文章到了这里，我们已经知道了怎样获取RecyclerView的LastVisibleItemPosition和总的条目数，那什么时候来比较这两个数值的大小呢？当然是RecyclerView停止滚动时来比较了，用过ListView的应该知道ListView有一个监听滑动状态的方法，同样RecyclerView也有这个方法，就是**onScrollStateChanged**(int state)，RecyclerView的滑动状态分别对应**RecyclerView.SCROLL_STATE_DRAGGING**、**RecyclerView.SCROLL_STATE_SETTLING**和**RecyclerView.SCROLL_STATE_IDLE**三个字段，这个三个字段分别代表手指在屏幕上拖动、拖动后的惯性滑动和拖动之后停止滑动。讲明白之后，下面看代码
```java
@Override
    public void onScrollStateChanged(int state) {
        //手指滑动后离开屏幕的状态
        if (state == RecyclerView.SCROLL_STATE_IDLE) {
            if (mLoadMoreEnabled) {
                LayoutManager layoutManager = getLayoutManager();
                int visibleItemCount = layoutManager.getChildCount();
                int totalItemCount = layoutManager.getItemCount();
                //mLastVisibleItemPosition >= totalItemCount-1是因为添加了一个FooterView
                //totalItemCount>visibleItemCount是限制当totalItemCount没铺满屏幕时不显示FooterView
                if (visibleItemCount > 0
                        && mLastVisibleItemPosition >= totalItemCount-1
                        && totalItemCount>visibleItemCount
                        && !isNoMore) {
                    mFootView.setVisibility(View.VISIBLE);//这里显示FootView
                    if (mLoadingData) {
                        return;
                    } else {
                        mLoadingData = true;
                        mILoadMoreFooter.onLoading();//方法回调
                        if (mLoadMoreListener != null) {
                            mLoadMoreListener.onLoadMore();
                        }
                    }
                }
            }
        }
    }
```
代码中一些可能比较绕的地方已经进行了注释，这里就不再讲解了，已经知道了怎样控制FooterView的显示隐藏，下一步就是改变FooterView的状态了。
### 改变FooterView的状态
&emsp;&emsp;因为是在RecyclerView中来改变FooterView的状态的，所以这里需要定义一个回调接口，如下
```java
public interface ILoadMoreFooter {

    void onReset();//正常的状态下

    void onLoading();//正在加载中的状态

    void onComplete();//已经加载完成

    void LoadNoMore();//没有更多数据

    View getFooterView();//获取FooterView

}
```
再看下FooterView的代码
```java
public class LoadMoreFooter extends RelativeLayout implements ILoadMoreFooter{
    private State mState;
    private View mLoadingView; //正在加载的图标
    private View mTheEndView; //加载全部的图标
  
    //此处省略部分代码

    public LoadMoreFooter(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);

    }

    private void init(Context context) {
        inflate(context, R.layout.layout_recyclerview_footer, this);
        onReset();
    }

    @Override
    public void onReset() {
        onComplete();
    }

    @Override
    public void onLoading() {
        setState(State.Loading);
    }

    @Override
    public void onComplete() {
        setState(State.Normal);
    }

    @Override
    public void LoadNoMore() {
        setState(State.NoMore);
    }

    private void setState(State state) {
        if (mState == state) {
            return;
        }
        mState = state;
        switch (state) {
            case Normal:
                if (mLoadingView != null) {
                    mLoadingView.setVisibility(GONE);
                }

                if (mTheEndView != null) {
                    mTheEndView.setVisibility(GONE);
                }

                break;
            case Loading:

                if (mTheEndView != null) {
                    mTheEndView.setVisibility(GONE);
                }
                
                if (mLoadingView == null) {
                    ViewStub viewStub = findViewById(R.id.loading_viewstub);
                    mLoadingView= viewStub.inflate();
                }
                mLoadingView.setVisibility(VISIBLE);

                break;
            case NoMore:
                if (mLoadingView != null) {
                    mLoadingView.setVisibility(GONE);
                }
                if (mTheEndView == null) {
                    ViewStub viewStub = findViewById(R.id.end_viewstub);
                    mTheEndView= viewStub.inflate();
                }
                mTheEndView.setVisibility(VISIBLE);
                break;
        }
    }

    @Override
    public View getFooterView() {
        return this;
    }

    public enum State {
        Normal,
        Loading,
        NoMore,
    }
}
```
可以看到，这里面的主要代码就是**setState**方法中的代码，**setState**方法中的代码也比较简单就是控制布局的显示隐藏。文章到了这里，已经将实现RecyclerView加载更多的功能中的主要的部分讲解完了，下面看下效果图
![](https://user-gold-cdn.xitu.io/2017/12/26/160934aae1252107?w=320&h=587&f=gif&s=1349885)
## 结束语
&emsp;&emsp;文中只是贴出了一些比较重要的代码，获取完整的代码，[点击这里](https://github.com/funaihui/LoadMoreForRecyclerView)。
> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>
