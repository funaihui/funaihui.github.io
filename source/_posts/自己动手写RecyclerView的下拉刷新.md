---
title: 自己动手写RecyclerView的下拉刷新
date: 2017-12-02 20:09:53
tags: 
- Android
-  RecyclerView 
-  下拉刷新
categories: 
- Android
---

> 实现RecyclerView下拉刷新的功能，网上有很多文章，但大多文章都是将RecyclerView外面套了一层SwipRefreshLayout以此来达到下拉刷新的目的！个人觉得这种方式不太优雅，于是通过查找资料及阅读源码，找到了一个比较优雅的方式实现RecyclerView的下拉刷新，本文将带你以一种优雅的方式实现RecyclerView的下拉刷新。

<!-- more -->

## 从基础入手

&emsp;&emsp;万丈高楼平地起，做什么事都不是一蹴而就的，再伟大的工程也是一点点完成的。这里就先从简单的入手，先为RecyclerView添加头部。

### 为RecyclerView添加头部View

&emsp;&emsp;我们都知道实现RecyclerView的数据和视图的绑定是通过继承RecyclerView.Adapter类，同样，为RecyclerView添加头部也是需要继承RecyclerView.Adapter类，然后，在子类里面做文章。在添加头部之前有必要先了解一下RecyclerView.Adapter的几个常用的方法，分别为以下几个方法

>```java
>onCreateViewHolder(ViewGroup parent, int viewType)
>```

> ```java
> getItemViewType(int position)
> ```

> ```java
> onBindViewHolder(MyViewHolder holder, int position)
> ```

> ```java
> getItemCount()
> ```

使用过ListView的都知道，为了优化ListView的性能，我们在写Adapter时需要自己写一个ViewHolder类来重用ListView中的item视图，而在为RecyclerView实现Adapter时，强制我们要有一个ViewHolder。

**onCreateViewHolder**方法就是用来创建新View;

**getItemViewType**方法是可以根据不同的*position*可以返回不同的类型;

**onBindViewHolder**是将数据与视图绑定;

**getItemCount**方法就是获得需要显示数据的总数。

&emsp;&emsp;了解了Adapter中的几个方法，下面就利用这几个方法为RecyclerView添加头部View，下面上代码

```java
@Override
    public RefreshViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
      //这里的viewType即为getItemViewType返回的type
        if (viewType == TYPE_REFRESH_HEADER) {
            return new RefreshViewHolder(mInflater.inflate(R.layout.refresh_header_item, parent, false));
        }
        return new RefreshViewHolder(mInflater.inflate(R.layout.normal_item, parent, false));
    }

    @Override
    public void onBindViewHolder(RefreshViewHolder holder, int position) {

    }

    @Override
    public int getItemCount() {
        return mLists.size();
    }

    @Override
    public int getItemViewType(int position) {
      //当position位置为0时，返回为头部的类型
        if (position == 0) {
            return TYPE_REFRESH_HEADER;
        }
        return TYPE_NORMAL;
    }
```

可以看出，在**onCreateViewHolder**方法中，为不同的viewType设置了不同的类型，即为RecyclerView添加了头部，看下效果图

![RecyclerView添加头部视图](https://user-gold-cdn.xitu.io/2017/12/2/160178961ae2f3f2?w=462&h=755&f=png&s=48733)

好了，现在已经为RecyclerView添加了头部，下一步就是将头部变成刷新的View。

## 添加下拉刷新的View

&emsp;&emsp;现在将头部View修改一下，直接上代码

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:gravity="bottom">

    <RelativeLayout
        android:id="@+id/header_content"
        android:layout_width="match_parent"
        android:layout_height="80dp"
        android:paddingTop="10dip">

        <TextView
            android:id="@+id/tvRefreshStatus"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_centerInParent="true"
            android:text="@string/pullRefresh"
            android:textColor="#B5B5B5" />

        <ImageView
            android:id="@+id/ivHeaderArrow"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_centerVertical="true"
            android:layout_marginLeft="35dp"
            android:layout_marginRight="10dp"
            android:layout_toLeftOf="@id/tvRefreshStatus"
            android:src="@drawable/ic_pulltorefresh_arrow" />
    </RelativeLayout>

</LinearLayout>
```

好了，看下效果图

![头部修改为下拉刷新](https://user-gold-cdn.xitu.io/2017/12/3/16019fd1c663bf71?w=411&h=671&f=png&s=37708)

现在这个效果显然不是我们想要的，我们想要的效果是在正常状态下头部的下拉刷新不可见，当下拉到一定程度再显示。

&emsp;&emsp;这里有两点需要注意：

1. 在正常的状态下，下拉刷新的头部是不可见的；
2. 当下拉到一定程度再将头部刷新显示出来。

现在，来实现正常状态下的效果，正常状态下不可见，这时可以将头部刷新的View高度设置为0，下面看下代码

```java
public ArrowRefreshHeader(Context context) {
        this(context,null);
    }

    public ArrowRefreshHeader(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs,0);
    }

    public ArrowRefreshHeader(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();//初始化视图
    }

    private void init() {
        LinearLayout.LayoutParams layoutParams = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutParams.setMargins(0, 0, 0, 0);
        this.setLayoutParams(layoutParams);
        this.setPadding(0, 0, 0, 0);

        //将refreshHeader高度设置为0
        mContentLayout = (LinearLayout) LayoutInflater.from(getContext()).inflate(R.layout.refresh_header_item, null);
        addView(mContentLayout, new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0));

        //初始化控件
        mArrowImageView = findViewById(R.id.ivHeaderArrow);
        mStatusTextView =  findViewById(R.id.tvRefreshStatus);
        mProgressBar = findViewById(R.id.refreshProgress);

        //初始化动画
        mRotateUpAnim = new RotateAnimation(0.0f, -180.0f,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        mRotateUpAnim.setDuration(200);
        mRotateUpAnim.setFillAfter(true);
        mRotateDownAnim = new RotateAnimation(-180.0f, 0.0f,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        mRotateDownAnim.setDuration(200);
        mRotateDownAnim.setFillAfter(true);

        //将mContentLayout的LayoutParams高度和宽度设为自动包裹并重新测量
        measure(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        mMeasuredHeight = getMeasuredHeight();//获得测量后的高度
    }
```

这里使用了自定义View，写了一个ArrowRefreshHeader继承至LinearLayout，在构造方法中将头部刷新的View进行了初始化，这里这句代码是关键

```java
mContentLayout = (LinearLayout) LayoutInflater.from(getContext()).inflate(R.layout.refresh_header_item, null);
        addView(mContentLayout, new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0));
```

可以看到，这里将头部刷新的View的高度设置成了0，这样，就实现了在正常状态下，头部刷新不显示的效果。将RefreshHeaderAdapter的onCreateViewHolder方法修改一下，如下

```java
 @Override
    public RefreshViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == TYPE_REFRESH_HEADER) {
//            return new RefreshViewHolder(mInflater.inflate(R.layout.refresh_header_item, parent, false));
            return new RefreshViewHolder(new ArrowRefreshHeader(mContext));
        }

        return new RefreshViewHolder(mInflater.inflate(R.layout.normal_item, parent, false));
    }
```

再看下效果

![不显示头部刷新](https://user-gold-cdn.xitu.io/2017/12/3/1601a25b1a262f80?w=407&h=671&f=png&s=39484)

成功实现在正常状态下不显示头部刷新View的效果，下面继续实现第2步，当下拉到一定程度进行显示。既然这里有下拉，肯定涉及到了手势监听，自然是需要一个类继承自RecyclerView，然后重写onTouchEvent方法，下面看代码

```java
@Override
    public boolean onTouchEvent(MotionEvent e) {
        if (mLastY == -1) {
            mLastY = e.getRawY();
        }
        switch (e.getAction()) {
            case MotionEvent.ACTION_DOWN:
                mLastY = e.getRawY();
                sumOffSet = 0;
                break;
            case MotionEvent.ACTION_MOVE:
                float deltaY = (e.getRawY() - mLastY) / 2;//为了防止滑动幅度过大，将实际手指滑动的距离除以2
                mLastY = e.getRawY();
                sumOffSet += deltaY;//计算总的滑动的距离
                if (isOnTop() && !mRefreshing) {
                    mRefreshHeader.onMove(deltaY, sumOffSet);//接口回调，移动刷新的头部View
                    if (mRefreshHeader.getVisibleHeight() > 0) {
                        return false;
                    }
                }
                break;
                default:
                    mLastY = -1; // reset
                    if (isOnTop()&& !mRefreshing) {
                        if (mRefreshHeader.onRelease()) {
                            //手指松开
                        }
                    }
                    break;
        }
        return super.onTouchEvent(e);
    }

```

这部分代码就是获取手指滑动的距离，然后利用接口回调，将下拉的距离传递到自定义的View中，让头部刷新的View改变距离及改变状态。先看下定义的接口，接口中主要就是集中刷新的状态以及代表各个状态的变量，代码如下

```java
public interface IRefreshHeader {
    int STATE_NORMAL = 0;//正常状态
    int STATE_RELEASE_TO_REFRESH = 1;//下拉的状态
    int STATE_REFRESHING = 2;//正在刷新的状态
    int STATE_DONE = 3;//刷新完成的状态

    void onReset();

    /**
     * 处于可以刷新的状态，已经过了指定距离
     */
    void onPrepare();

    /**
     * 正在刷新
     */
    void onRefreshing();

    /**
     * 下拉移动
     */
    void onMove(float offSet, float sumOffSet);

    /**
     * 下拉松开
     */
    boolean onRelease();

    /**
     * 下拉刷新完成
     */
    void refreshComplete();

    /**
     * 获取HeaderView
     */
    View getHeaderView();

    /**
     * 获取Header的显示高度
     */
    int getVisibleHeight();
}
```

我们的自定义View即ArrowRefreshHeader这个类实现了上面的接口，上面说道，通过接口回调的形式将移动的距离通过onMove方法回传给了ArrowRefreshHeader，现在看下ArrowRefreshHeader中onMove方法的具体实现，如下

```java
if (getVisibleHeight() > 0 || offSet > 0) {
            setVisibleHeight((int) offSet + getVisibleHeight());
            if (mState <= STATE_RELEASE_TO_REFRESH) { // 未处于刷新状态，更新箭头
                if (getVisibleHeight() > mMeasuredHeight) {
                    onPrepare();
                } else {
                    onReset();
                }
            }
        }
```

这里将移动的距离通过setVisibleHeight方法进行显示，再看下这个方法的实现

```java
public void setVisibleHeight(int height) {
        if (height < 0) height = 0;
        LayoutParams lp = (LayoutParams) mContentLayout.getLayoutParams();
        lp.height = height;
        mContentLayout.setLayoutParams(lp);
    }
```

这个方法的主要功能就是将距离设置给了LayoutParams中的height字段，然后再重新设置mContentLayout的布局属性。

&emsp;&emsp;通过以上的方法，便可以实现当下拉到一定距离时显示头部刷新View的功能了，下面看下实现的效果

![下拉刷新实现的效果](https://user-gold-cdn.xitu.io/2017/12/3/1601ab669d638078?w=320&h=588&f=gif&s=1077447)

到了这一步已经可以实现下拉以及刷新的功能了，但是只会一直刷新，根本停不下来！这里是因为我们没有调用刷新完成的回调方法，下面开始实现刷新完成是的功能。

## 刷新完成的实现及设置刷新时的监听

### 实现完成刷新的功能

现在看下当刷新的状态变为刷新完成，做了什么

```java
 @Override
    public void refreshComplete() {
        setState(STATE_DONE);//设置刷新的状态为已完成
        //延迟200ms后复位，主要是为了显示“刷新完成”的字样，不延迟的话由于时间太短就看不见“刷新完成”的字样
        new Handler().postDelayed(new Runnable() {
            public void run() {
                reset();
            }
        }, 200);
    }
```

可以看到**refreshComplete**方法主要是将状态标志位设置为已完成，同时延迟200ms将下来刷新的状态复位，下面分别看下**setState**方法和**reset**方法都做了什么

```java
public void setState(int state) {
        //状态没有改变时什么也不做
        if (state == mState) return;
        switch (state) {
            case STATE_NORMAL:
                if (mState == STATE_RELEASE_TO_REFRESH) {
                    mArrowImageView.startAnimation(mRotateDownAnim);
                }
                if (mState == STATE_REFRESHING) {
                    mArrowImageView.clearAnimation();
                }
                mStatusTextView.setText("下拉刷新");
                break;
            case STATE_RELEASE_TO_REFRESH:
                mArrowImageView.setVisibility(View.VISIBLE);
                mProgressBar.setVisibility(View.INVISIBLE);
                if (mState != STATE_RELEASE_TO_REFRESH) {
                    mArrowImageView.clearAnimation();
                    mArrowImageView.startAnimation(mRotateUpAnim);
                    mStatusTextView.setText("释放立即刷新");
                }
                break;
            case STATE_REFRESHING:
                mArrowImageView.clearAnimation();
                mArrowImageView.setVisibility(View.INVISIBLE);
                mProgressBar.setVisibility(View.VISIBLE);
                smoothScrollTo(mMeasuredHeight);
                mStatusTextView.setText("正在刷新...");

                break;
            case STATE_DONE:
                mArrowImageView.setVisibility(View.INVISIBLE);
                mProgressBar.setVisibility(View.INVISIBLE);
                mStatusTextView.setText("刷新完成");
                break;
            default:
        }
        mState = state;//保存当前刷新的状态
    }
```

在**setState**方法里，主要及时根据不同的刷新状态的标志，设置视图的显示隐藏以及文字的改变。

```java
public void reset() {
        smoothScrollTo(0);
        setState(STATE_NORMAL);
    }
```

**reset**方法就是将头部刷新View的高度还设置为0，就是将头部刷新View隐藏通知将刷新的状态设置为*STATE_NORMAL*。

看完了方法，下面就在自己实现的RecyclerView中调用刷新完成的方法，代码如下

```java
public void refreshComplete() {
        if (mRefreshing) {
            mRefreshing = false;
            mRefreshHeader.refreshComplete();
        }
    }
```

### 设置刷新时的监听

这里，将刷新时的监听放在当刷新视图显示正在刷新时，即当触发了刷新并且手指抬起时，可能说的难懂，相信看下代码就明白了

```java
 mLastY = -1; // reset
if (isOnTop()&& !mRefreshing) {
    if (mRefreshHeader.onRelease()) {
     //手指松开
        if (mRefreshListener != null) {
            mRefreshing = true;
            mRefreshListener.onRefresh();//调用正在刷新的监听，在此方法中实现网络的请求操作。
        }
     }
 }
```

## 下拉刷新的使用

&emsp;&emsp;下拉刷新的功能已经全部完成了，下面看下怎么使用

```java
public class MainActivity extends AppCompatActivity {
    private List<String> mStringList = new ArrayList<>();
    private RefreshHeaderRecyclerView mRecyclerView;
    private RefreshHeaderAdapter mAdapter;
    private static final int FINISH = 1;

    @SuppressLint("HandlerLeak")
    private  Handler sHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == FINISH) {
                Toast.makeText(MainActivity.this,"刷新完成！",Toast.LENGTH_SHORT).show();
                mRecyclerView.refreshComplete();
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initData();
        setupRecyclerView();
    }

    private void setupRecyclerView() {
        mRecyclerView = findViewById(R.id.recyclerView);
        mAdapter = new RefreshHeaderAdapter(mStringList, this);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mRecyclerView.setAdapter(mAdapter);
        mRecyclerView.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh() {
                requestData();//模拟数据的请求

            }
        });
    }

    private void requestData() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                MainActivity.this.toString();
                try {
                    Thread.sleep(1500);
                    Message message = Message.obtain();
                    message.what = FINISH;
                    sHandler.sendMessage(message);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

            }
        }).start();
    }

    private void initData() {
        for (int i = 0; i < 15; i++) {
            mStringList.add("");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        sHandler.removeCallbacks(null);
    }
}
```

上面的代码不难，相信你一看就懂，这里就不讲解了,看下最终的效果，如图

## 实现下拉刷新的步骤总结

1. 自定义Adapter继承至RecyclerView的Adapter
2. 重写getItemType()方法
3. 在onCreateViewHolder()方法中实例化RefreshHeader对象。
4. 新建一个类继承至LinearLayout并实现IRehreshView接口
5. 在初始化时将布局属性设置为0,既隐藏头部刷新。
6. 重写RecyclerView主要是重写RecyclerView的onTouchEvent方法，根据滑动的距离来显示头部刷新的View
7. 设置监听

## 结束语

&emsp;&emsp;相信按照上面的步骤，你一定可以自己动手实现RecyclerView的下拉刷新功能。源码[点击这里获取](https://github.com/funaihui/RefreshHeaderRecyclerView)

> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.cn](http://www.wizardev.cn)<font>

