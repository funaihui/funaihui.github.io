---
title: Android底部弹窗的正确打开方式
date: 2017-09-13 19:51:03
tags: 
- Android
- PopupWindow
- Dialog
categories: 
- Android
---
> 本文主要是介绍Android中实现底部弹窗的的正确姿势，如果你在实现底部弹窗时遇到了一些问题，那么请仔细阅读本文，相信文章会对你有所帮助。

<!-- more -->
# 收获早知道
&emsp;&emsp;<font color=green size=4>阅读完本文后，你可以有以下收获</font>
- 利用PopupWindow实现底部弹窗
- PopupWindow实现底部弹窗时的缺点
- 解决利用PopupWindow实现底部弹窗，无法覆盖状态栏的问题
- 利用dialog实现底部弹窗
- 利用dialogFragment实现底部弹窗

# 实现底部弹窗的方式
&emsp;&emsp;由于本人水平有限，只知道一下几种实现底部弹窗的方式
1. 利用PopupWindow实现底部弹窗。
2. 利用Dialog实现底部弹窗。
3. 利用DialogFragment实现底部弹窗。

下面，就利用以上三种方式分别实现Android中的底部弹窗。
## 利用PopWindow实现底部弹窗
&emsp;&emsp;因为本文主要是介绍实现底部弹窗的方式，所以，不会对PopupWindow进行具体的讲解，大家可以到[这里了解PopupWindow](https://developer.android.google.cn/reference/android/widget/PopupWindow.html)。

&emsp;&emsp;直接进入主题，按照套路，一步步实现利用PopupWindow实现底部弹窗。首先，写一个布局文件作为PopupWindow中的内容，布局文件如下
```
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:background="#553b3a3a"
    android:layout_height="match_parent">
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_alignParentBottom="true"
        android:orientation="vertical"
        android:id="@+id/content"
        android:background="@android:color/white"
        android:layout_height="wrap_content">
        <TextView
            android:layout_width="match_parent"
            android:textColor="#333"
            android:text="相机"
            android:padding="8dp"
            android:id="@+id/open_from_camera"
            android:gravity="center"
            android:textSize="15sp"
            android:layout_height="40dp" />
        <TextView
            android:layout_marginTop="1dp"
            android:id="@+id/open_album"
            android:layout_width="match_parent"
            android:textColor="#333"
            android:text="打开图库"
            android:padding="8dp"
            android:gravity="center"
            android:textSize="15sp"
            android:layout_height="40dp" />
        <TextView
            android:layout_marginTop="1dp"
            android:id="@+id/cancel"
            android:layout_width="match_parent"
            android:textColor="#333"
            android:text="取消"
            android:padding="8dp"
            android:gravity="center"
            android:textSize="15sp"
            android:layout_height="40dp" />
    </LinearLayout>
</RelativeLayout>
```
<font color=red size = 4>注：</font>这里使用的是填充父窗口的方式，如果不这样做的话，就不能看出遮住后面的效果，看下图更容易理解，左图为填充父布局的方式，右图为
自适应的方式
<figure class="half">
    <img src="http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_016.png" title="填充父布局的方式">
    <img src="http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_017.png" title="自适应的方式">
</figure>
<font color=red size = 4>注：</font>因为采用填充父布局的方式，这里弹出的窗口都是PopupWindow，所以点击左图中的阴影弹窗不会消失，因为阴影也是PopupWindow呀！<font color=green> 解决方法就是，把左图中的阴影部分用一个TextView控件填充，然后为这个TextView设置点击事件，点击TextView时让PopupWindow消失就行了</font>。

下面看下利用PopupWindow实现底部弹窗的代码，重要的方法我会具体讲解
```
private void initPopupWindow() {
		//要在布局中显示的布局
        contentView = LayoutInflater.from(this).inflate(R.layout.popup_layout, null, false);
        //实例化PopupWindow并设置宽高
        popupWindow = new PopupWindow(contentView, LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
        popupWindow.setBackgroundDrawable(new BitmapDrawable());
        //点击外部消失，这里因为PopupWindow填充了整个窗口，所以这句代码就没用了
        popupWindow.setOutsideTouchable(true);
        //设置可以点击
        popupWindow.setTouchable(true);
        //进入退出的动画
        popupWindow.setAnimationStyle(R.style.MyPopWindowAnim);
    }

    private void showPopWindow() {
        View rootview = LayoutInflater.from(MainActivity.this).inflate(R.layout.activity_main, null);
        popupWindow.showAtLocation(rootview, Gravity.BOTTOM, 0, 0);  
    }
```
重点看一下这句代码
```
popupWindow.showAtLocation(rootview, Gravity.BOTTOM, 0, 0);  
```
这句代码是设置弹出窗口从哪里弹出，**void showAtLocation (View parent,int gravity,int x,int y)**方法有四个参数，第一个参数是父布局，第二个为从父布局的哪里弹出，x和y是相对于父布局弹出位置的偏移量。由于，我们要将mPopWindow放在整个屏幕的最低部，所以我们将R.layout.activity_main做为它的父容器，将其显示在BOTTOM的位置。

&emsp;&emsp;再仔细看下上图，利用PopupWindow实现从底部的弹窗并不能覆盖到状态栏，下面就来解决这个问题。
### 解决PopupWindow弹出的窗口不能覆盖状态栏问题
&emsp;&emsp;想要覆盖到状态栏还需要添以下代码
```
//弹出的窗口是否覆盖状态栏
    public void fitPopupWindowOverStatusBar(boolean needFullScreen) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            try {
                //利用反射重新设置mLayoutInScreen的值，当mLayoutInScreen为true时则PopupWindow覆盖全屏。
                Field mLayoutInScreen = PopupWindow.class.getDeclaredField("mLayoutInScreen");
                mLayoutInScreen.setAccessible(true);
                mLayoutInScreen.set(popupWindow, needFullScreen);
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
    }
```
再改变一下显示PopupWindow的代码，如下
```
 		//设置是否遮住状态栏
        fitPopupWindowOverStatusBar(true);
        View rootview = LayoutInflater.from(MainActivity.this).inflate(R.layout.activity_main, null);
        popupWindow.showAtLocation(rootview, Gravity.BOTTOM, 0, 0);
```
再看下效果
<center>![](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_018.png)</center>
好了，到此完美解决问题，可以发现利用PopupWindow实现底部弹窗其实还是挺麻烦的。
## 利用Dialog实现底部弹窗
&emsp;&emsp;先看下代码，然后在讲解
```
public class DialogFromBottom extends Dialog{
    private final static int mAnimationDuration = 200;
    // 持有 ContentView，为了做动画
    private View mContentView;
    private boolean mIsAnimating = false;

    private OnBottomSheetShowListener mOnBottomSheetShowListener;

    public DialogFromBottom(@NonNull Context context) {
        super(context, R.style.AppTheme_BottomSheet);
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getDecorView().setPadding(0, 0, 0, 0);
        // 在底部，宽度撑满
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
        params.gravity = Gravity.BOTTOM | Gravity.CENTER;//dialog从哪里弹出
        //弹出窗口的宽高
        int screenWidth = QMUIDisplayHelper.getScreenWidth(getContext());
        int screenHeight = QMUIDisplayHelper.getScreenHeight(getContext());
        params.width = screenWidth < screenHeight ? screenWidth : screenHeight;
        getWindow().setAttributes(params);
        setCanceledOnTouchOutside(true);
    }
    //设置弹出dialog中的layout
    @Override
    public void setContentView(int layoutResID) {
        mContentView = LayoutInflater.from(getContext()).inflate(layoutResID, null);
        super.setContentView(mContentView);
    }

    @Override
    public void setContentView(@NonNull View view) {
        mContentView = view;
        super.setContentView(view);
    }

    @Override
    public void setContentView(@NonNull View view, ViewGroup.LayoutParams params) {
        mContentView = view;
        super.setContentView(view, params);
    }
    /**
     * BottomSheet升起动画
     */
    private void animateUp() {
        if (mContentView == null) {
            return;
        }
        TranslateAnimation translate = new TranslateAnimation(
                Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
                Animation.RELATIVE_TO_SELF, 1f, Animation.RELATIVE_TO_SELF, 0f
        );
        AlphaAnimation alpha = new AlphaAnimation(0, 1);
        AnimationSet set = new AnimationSet(true);
        set.addAnimation(translate);
        set.addAnimation(alpha);
        set.setInterpolator(new DecelerateInterpolator());
        set.setDuration(mAnimationDuration);
        set.setFillAfter(true);
        mContentView.startAnimation(set);
    }

    /**
     * BottomSheet降下动画
     */
    private void animateDown() {
        if (mContentView == null) {
            return;
        }
        TranslateAnimation translate = new TranslateAnimation(
                Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 0f,
                Animation.RELATIVE_TO_SELF, 0f, Animation.RELATIVE_TO_SELF, 1f
        );
        AlphaAnimation alpha = new AlphaAnimation(1, 0);
        AnimationSet set = new AnimationSet(true);
        set.addAnimation(translate);
        set.addAnimation(alpha);
        set.setInterpolator(new DecelerateInterpolator());
        set.setDuration(mAnimationDuration);
        set.setFillAfter(true);
        set.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                mIsAnimating = true;
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                mIsAnimating = false;
                /**
                 * Bugfix： Attempting to destroy the window while drawing!
                 */
                mContentView.post(new Runnable() {
                    @Override
                    public void run() {
                        // java.lang.IllegalArgumentException: View=com.android.internal.policy.PhoneWindow$DecorView{22dbf5b V.E...... R......D 0,0-1080,1083} not attached to window manager
                        // 在dismiss的时候可能已经detach了，简单try-catch一下
                        try {
                            DialogFromBottom.super.dismiss();
                        } catch (Exception e) {
                        //这里处理异常
                        }
                    }
                });
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        mContentView.startAnimation(set);
    }

    @Override
    public void show() {
        super.show();
        animateUp();
        if (mOnBottomSheetShowListener != null) {
            mOnBottomSheetShowListener.onShow();
        }
    }

    @Override
    public void dismiss() {
        if (mIsAnimating) {
            return;
        }
        animateDown();
    }
    public interface OnBottomSheetShowListener {
        void onShow();
    }
}
```
额，代码有点长，其实很容易理解，这里主要说下onCreate方法中的内容，可以仔细看下注释。
```
 @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getDecorView().setPadding(0, 0, 0, 0);//把父布局的padding都设为0，目的是可以dialog撑满全屏。
        // 在底部，宽度撑满
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
        params.gravity = Gravity.BOTTOM | Gravity.CENTER;//dialog从底部弹出
        //弹出窗口的宽高，DisplayHelper.getScreenWidth(getContext());和DisplayHelper.getScreenHeight(getContext());是拿到屏幕的宽高。
        int screenWidth = DisplayHelper.getScreenWidth(getContext());
        int screenHeight = DisplayHelper.getScreenHeight(getContext());
        params.width = screenWidth < screenHeight ? screenWidth : screenHeight;//适配手机横屏
        getWindow().setAttributes(params);//重新设置dialog的属性
        setCanceledOnTouchOutside(true);//设置触摸dialog以外，dialog是否消失
    }
```
利用Dialog实现底部弹窗就是继承系统Dialog然后重写了onCreate方法，设置dialog从底部弹出。因为是继承Dialog，所以有Dialog的特性，既触摸底部弹窗以外的部分，弹窗会自动消失，这里就不在演示，可以在文末获取源码，自己实验一下就知道了。
## 利用DialogFragment实现底部弹窗
&emsp;&emsp;在实现弹窗之前，先了解一下DialogFragment
>  DialogFragment在android 3.0时被引入。是一种特殊的Fragment，用于在Activity的内容之上展示一个模态的对话框。

&emsp;&emsp;使用DialogFragment至少需要实现onCreateView或者onCreateDIalog方法。onCreateView即使用定义的xml布局文件展示Dialog。onCreateDialog即利用AlertDialog或者Dialog创建出Dialog。下面通过实现onCreateView方法来实现底部弹窗。
```
 @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.dialog_layout, container, false);
        return view;
    }
    @Override
    public void onStart() {
        super.onStart();
        initParams();//初始化弹窗的参数
    }
    private void initParams() {
        Window window = getDialog().getWindow();
        if (window != null) {
            WindowManager.LayoutParams lp = window.getAttributes();
            //调节灰色背景透明度[0-1]，默认0.5f
            lp.dimAmount = dimAmount;
            //是否在底部显示
            if (showBottom) {
                lp.gravity = Gravity.BOTTOM;
                if (animStyle == 0) {
                    animStyle = R.style.DefaultAnimation;
                }
            }
            //设置dialog宽度
            if (width == 0) {
                lp.width = DisplayHelper.getScreenWidth(getActivity()) - 2 * DisplayHelper.dp2px(getActivity(), margin);
            } else {
                lp.width = DisplayHelper.dp2px(getActivity(), width);
            }
            //设置dialog高度
            if (height == 0) {
                lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
            } else {
                lp.height = DisplayHelper.dp2px(getActivity(), height);
            }
            //设置dialog进入、退出的动画
            window.setWindowAnimations(animStyle);
            window.setAttributes(lp);
        }
        setCancelable(outCancel);//设置点击外部是否消失
    }
```
因为DialogFragment也是Fragment，所以，DialogFragment有和Fragment一样的生命周期，在onStart方法中初始化弹窗的数据，在onCreateView中加载布局，同样，和Fragment使用方法也是一样的，下面看下在Activity中的使用
```
void showDialog() {
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        // Create and show the dialog.
        DialogFragmentFromBottom newFragment = new DialogFragmentFromBottom();
        newFragment.show(ft, "dialog");
    }
```
# 结束语
&emsp;&emsp;好了，到这里三种实现底部弹窗的方式已经讲完了，大家可以下载源码研究一下，[源码在这里](https://github.com/funaihui/FromBottomDialog),在做项目时选择最适合的就好，在这里还是推荐使用DialogFragment，这种方式可定制性很高，实现弹窗的方式也比较优雅。
> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>