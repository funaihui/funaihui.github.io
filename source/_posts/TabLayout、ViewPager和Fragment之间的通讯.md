---
title: TabLayout、ViewPager和Fragment之间的通讯
date: 2017-08-01 19:29:31
tags: 
- Android 
- TabLayout 
- ViewPager
- Fragment
categories: 
- Android
---
> 在做项目时经常会遇到TabLayout、ViewPager和Fragment结合使用，但怎样把选中的Tab的类型传递给Fragment，让Fragment加载不同的数据呢？如果你遇到了这个问题，你可以在本文中得到答案。


<!-- more -->
## 分析需求
&emsp;&emsp;在动手撸代码之前，我们先理一下需求，这里的需求是选中不同的TabLayout中的Tab让Fragment加载不同的数据，这里就有了几个问题：
- 怎样知道是哪一个Tab被选中
- 怎样把选中的tab的类型传递给Fragment，让Fragment加载不同的数据
- 监测Fragment在ViewPager中的滑动，选中TabLayout中的Tab

## 搭建模型
&emsp;&emsp;在解决上面几个问题之前，我们先把TabLayout、ViewPager和Fragment在项目中如何使用的架子搭出来。
### 布局文件
```
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    tools:context="com.wizardev.tablayoutandviewpager.MainActivity">

<android.support.design.widget.TabLayout
    android:layout_width="match_parent"
    android:id="@+id/tabs"
    app:tabSelectedTextColor="@color/colorAccent"
    android:layout_height="wrap_content"/>

<android.support.v4.view.ViewPager
    android:id="@+id/viewPager"
    android:layout_width="match_parent"
    android:layout_height="match_parent"/>
</LinearLayout>
```
布局文件很简单，只是在LinearLayout中放了一个TabLayout和一个ViewPager，TabLayout是用来放tab的，我们的Fragment会放在布局中的ViewPager中。
### 代码
&emsp;&emsp;以下是MainActivity中的代码
```
public class MainActivity extends AppCompatActivity {
    private ViewPager mViewPager;
    private TabLayout mTabLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initView();
    }

    private void initView() {
        setContentView(R.layout.activity_main);
        mViewPager = (ViewPager) findViewById(R.id.viewPager);
        mTabLayout = (TabLayout) findViewById(R.id.tabs);
        if (mTabLayout != null) {
            mTabLayout.setupWithViewPager(mViewPager);
        }

        FragmentManager fm = getSupportFragmentManager();
        FragmentAdapter pagerAdapter = new FragmentAdapter(fm);
        pagerAdapter.addFragment(new MovieFragment(),"金刚狼");
        pagerAdapter.addFragment(new MovieFragment(),"金瓶梅");
        pagerAdapter.addFragment(new MovieFragment(),"老炮儿");
        mViewPager.setAdapter(pagerAdapter);
    }
}
```
我们发现Activity中的代码也很少，上面有几句代码比较重要，一句是
```
mTabLayout.setupWithViewPager(mViewPager);
```
这句代码是让TabLayout与ViewPager绑定，添加这句代码之后，我们滑动ViewPager时会选中不同的Tab，同样，我们点击Tab时也会切换不同的ViewPager。
还有一部分重要的代码是下面这一部分
```
FragmentManager fm = getSupportFragmentManager();
        FragmentAdapter pagerAdapter = new FragmentAdapter(fm);
        pagerAdapter.addFragment(new MovieFragment(),"金刚狼");
        pagerAdapter.addFragment(new MovieFragment(),"金瓶梅");
        pagerAdapter.addFragment(new MovieFragment(),"老炮儿");
        mViewPager.setAdapter(pagerAdapter);
```
这部分代码是往ViewPager中添加数据，也就是添加Fragment，这里我们用了一个FragmentAdapter，我们看下FragmentAdapterr中的代码
```
public class FragmentAdapter extends FragmentPagerAdapter {
    private List<Fragment> mFragments = new ArrayList<>();
    private List<String> mFragmentTitle = new ArrayList<>();

    public FragmentAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int position) {
        return mFragments.get(position);
    }

    public void addFragment(Fragment fragment, String title) {
        mFragments.add(fragment);//添加到List中
        mFragmentTitle.add(title);
    }

    @Override
    public int getCount() {
        return mFragments.size();
    }
	//这个方法是用来设置tab的name的
    @Override
    public CharSequence getPageTitle(int position) {
    	//从添加后的list中取数据并返回
        return mFragmentTitle.get(position);
    }
}
```
FragmentAdapter中的代码很简单，看下代码中的注释就能理解了.
&emsp;&emsp;下面看下我们的Fragment
```

public class MovieFragment extends Fragment{

    private TextView mMovie;
    private static final String MOVIE = "movie";
    private String mMovieName;
    private static final String TAG = "MovieFragment";

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_layout, container, false);
        mMovie = view.findViewById(R.id.movie);
        mMovie.setText(mMovieName);
        return view;
    }
}
```
MovieFragment很简单就是加载一个布局，而布局更简单，布局里面只有一个TextView用来显示不同的内容。完成了上面这些，一个简单的架子就搭出来了，接下来就是实现根据选中的tab不同Fragment加载不同的数据了。
## 根据选中的Tab不同Fragment加载不同的数据
&emsp;&emsp;这里我们就来解决上面提到的问题
- 怎样知道是哪一个Tab被选中
- 怎样把选中的tab的类型传递给Fragment，让Fragment加载不同的数据

在向FragmentAdapter中添加数据的时候，Tab根据添加的数据顺序依次进行显示，代码中我们是这样添加的
```
FragmentAdapter pagerAdapter = new FragmentAdapter(fm);
        pagerAdapter.addFragment(new MovieFragment(),"金刚狼");
        pagerAdapter.addFragment(new MovieFragment(),"金瓶梅");
        pagerAdapter.addFragment(new MovieFragment(),"老炮儿");
```
则TabLayout中依次从左到右显示添加的title，如下图.
<center>![图片1](http://ot6991tvl.bkt.clouddn.com/device-2017-08-01-222017.png)</center>
根据这个特性，便可以间接的为Tab添加上不同的标记，可以在往FragmentAdapter中添加Fragment时设置类型，就是在new Fragment时为Fragment设置Arguments，语言表述总是苍白的，直接看更改后的代码
```
FragmentManager fm = getSupportFragmentManager();
        FragmentAdapter pagerAdapter = new FragmentAdapter(fm);
        pagerAdapter.addFragment(MovieFragment.newInstance("金刚狼"),"金刚狼");
        pagerAdapter.addFragment(MovieFragment.newInstance("金瓶梅"),"金瓶梅");
        pagerAdapter.addFragment(MovieFragment.newInstance("老炮儿"),"老炮儿");
        mViewPager.setAdapter(pagerAdapter);
```
这里我们不是直接new MovieFragment了，而是在MovieFragment中添加了一个静态方法，可以看下这个静态方法
```
public static MovieFragment newInstance(String movie){
        MovieFragment movieFragment = new MovieFragment();
        Bundle bundle = new Bundle();
        bundle.putString(MOVIE,movie);
        movieFragment.setArguments(bundle);
        return movieFragment;
    }
```
这个方法不仅新建了一个MovieFragment，而且在建立时为当前的MovieFragment绑定了一个值，既是间接的为Tab设置了标记.
当选中不同的Tab，ViewPager加载Fragment时，Fragment便可以接收到不同的值，从而加载不同的数据.
可以在Fragment生命周期的onCreate()方法中接收设置的数据，参考代码如下
```
@Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle bundle = getArguments();
        if (bundle != null){
            mMovieName = bundle.getString(MOVIE);
        }else {
            mMovieName = "";
        }
    }
```
好了，到这里我们已经解决了开篇提到的问题，本文也该结束了.
## 结束语
&emsp;&emsp;由于这里没有对Fragmentr进行处理，加载数据时都是默认ViewPager的预加载功能，如果需要点击到Tab时在进行数据的加载，则需要改写Fragment中的代码，使ViewPager预加载功能失效.
>&emsp;&emsp;<font color = "green" size = "5">转载请注明出处：[www.wizardev.cn](http://www.wizardev.cn)<font>




