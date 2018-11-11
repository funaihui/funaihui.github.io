---
title: 从源码定制你的专属Next主题
date: 2017-07-16 14:36:46
tags: NexT Hexo
categories: 其他
---
&emsp;&emsp;利用Hexo框架搭建个人博客,[NexT](https://github.com/iissnan/hexo-theme-next)的主题绝对是你的首选,它自带三种主题,每种主题不仅非常简洁而且也非常有范,自带的动画效果也非常赞.虽然主题很好,但是呢我们每个人都有自己的特点和个性,肯定想拥有一个自己独一无二的博客主题,这篇博客就是教大家在NexT主题的基础上,进行自己的定制.
<!-- more -->
## 预览NexT主题
&emsp;&emsp;在开始定制之前,先了解下NexT主题自带的三个主题,分别是如下三种主题
- Muse - 默认 Scheme，这是 NexT 最初的版本，黑白主调，大量留白
- Mist - Muse 的紧凑版本，整洁有序的单栏外观
- Pisces - 双栏 Scheme，小家碧玉似的清新

这里我们可以看下三种主题的效果,如下图<center>
这是Muse主题
![Muse](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_001.png)</center>

<center>
这是Mist主题
![Muse](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_002.png)</center>

<center>
这是Pisces主题
![Pisces](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_003.png)</center>
&emsp;&emsp;我们可以发现Pisces主题和其他的两个色彩搭配并不一样,这是因为我比较喜欢Pisces主题的风格,所以就在Pisces主题上做了一些定制.我们来看一下没有经过定制的Pisces主题
<center>没有经过定制的Pisces主题![没有经过定制的Pisces主题](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_004.png)</center>
## 对比不同
&emsp;&emsp;这里我们来看下Pisces没有修改前的样子,左侧菜单栏头部为黑色,显示头像呢,显示的是方形的.而经过个人定制之后呢,头像变为了圆形,左侧菜单栏的头部也变成了颜色比较鲜艳的色彩.
## 从源码进行修改
&emsp;&emsp;修改之前,我们先对源码的布局有个大致的了解,以后想对哪里进行修改就可以直接到对应的文件夹,然后对里面的源码进行修改就行了.<br>
NexT源码主要文件夹布局如下<br>
---------------------languages(这里是与语言有关的,不用看)<br>
---------------------layout(这个文件夹内的内容与主题的布局有关)<br>
---------------------scripts(scripts文件,不用看)<br>
---------------------source(主题的css文件,字体文件以及第三方的库,与定制主题有关)<br>
---------------------test(这个不用看)<br>
### 修改菜单栏头部的颜色
&emsp;&emsp;我们可以在source文件夹下找到css文件然后对菜单栏的头部颜色进行修改,就在这个路径下
```
/home/wizardev/hexo/themes/hexo-theme-next/source/css/_schemes/这里是你自己选用的主题
```
我们看下这个路径下的<font color=green>_brand.styl</font>文件的内容
```
.site-brand-wrapper {
  position: relative;
}

.site-meta {
  padding: 20px 0;
  color: white;
  background: $blue-light;//这里及时菜单栏头部的颜色,我们可以在这里直接写#xxxxxx颜色代码,
  //也可以像我这样$blue-light取颜色值,当然这个值是在~/hexo-theme-next/source/css/_variables这个路径下的base.styl文件中定义过的.

  +tablet() {
    box-shadow: 0 0 16px rgba(0,0,0,0.5);
  }
  +mobile() {
    box-shadow: 0 0 16px rgba(0,0,0,0.5);
  }
}

.brand {
  padding: 0;
  background: none;

  &:hover { color: white; }
}

.site-subtitle {
  margin: 10px 10px 0;
  font-weight: initial;
}

.site-search form { display: none; }
```
什么,你问我怎么知道是在这里修改,其实很简单,我们可以用chorme浏览器看下菜单栏头部的名称,在chorme中打开配置好的NexT主题,按下F12,会出现一下界面
<center>![选取](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_005.png)</center>
我们选中菜单栏的头部,就会发现菜单栏的类名,如下图
<center>![选取](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_006.png)</center>
我们发现头部的名称为"site-meta",知道了菜单栏头部的类名,则就可以在CSS中自定义样式了,这些对有前端基础的来说应该不难.
### 修改头像的样式
&emsp;&emsp;和修改菜单栏头部颜色一样,我们还是先得到头像的类名,利用相同的方法,得到了头像的类名为"site-author-image",最后我们发现"site-author-image"位于一下路径中的<font color=green>sidebar-author.styl</font>文件中
```
~/hexo/themes/hexo-theme-next/source/css/_common/components/sidebar/
```
我们可以看下<font color=green>sidebar-author.styl</font>文件的源码,源码如下
```
//这是设置头像图片的样式
.site-author-image {
  display: block;
  margin: 0 auto;
  padding: $site-author-image-padding;
  max-width: $site-author-image-width;
  height: $site-author-image-height;
  border-radius: 50% //想让图片显示圆形,这样设置就可以了.
  border: $site-author-image-border-width solid $site-author-image-border-color;
}
//这是设置名字的样式
.site-author-name {
  margin: $site-author-name-margin;
  text-align: $site-author-name-align;
  color: $site-author-name-color;
  font-weight: $site-author-name-weight;
}
//这是设置描述的样式
.site-description {
  margin-top: $site-description-margin-top;
  text-align: $site-description-align;
  font-size: $site-description-font-size;
  color: $site-description-color;
}
```
我们自己想要什么样式在上面修改就行了,当然,需要一定的CSS基础才行.
### 其他设置
#### 修改底部显示的文字内容
&emsp;&emsp;可以在一下文件中修改网站底部显示的内容,什么,你居然问我什么是底部样式,嗯,看一下图就明白了
<center>![](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_007.png)</center>红框标出的就是底部的的内容了,我们可以在这里修改
```
~/hexo/themes/hexo-theme-next/layout/_partials/footer.swig
```
#### 调整头像的大小
&emsp;&emsp;可以在<font color=green>pisces.styl</font>文件中设置头像显示的大小.<font color=green>pisces.styl</font>文件在一下路径下
```
~/hexo/themes/hexo-theme-next/source/css/_variables/
```
我们来看一下<font color=green>pisces.styl</font>文件的源码,如下
```
// Scaffolding
// Settings for some of the most global styles.
// --------------------------------------------------
$body-bg-color                = #f5f7f9


// Borders
// --------------------------------------------------
$box-shadow-inner                 = initial;
$box-shadow                       = initial;

$border-radius-inner              = initial;
$border-radius                    = initial;


// Header
// --------------------------------------------------
$subtitle-color                   = $grey-dark

// Sidebar
// --------------------------------------------------
$sidebar-offset-float             = unit(hexo-config('sidebar.offset_float'), px) if hexo-config('sidebar.offset_float') is a 'unit'

$sidebar-nav-hover-color          = $orange
$sidebar-highlight                = $orange

$site-author-image-width          = 120px//这里就是对头像的大小进行设置
$site-author-image-border-width   = 1px
$site-author-image-border-color   = $gainsboro

$site-author-name-margin          = 0
$site-author-name-color           = $black-deep
$site-author-name-align           = center
$site-author-name-weight          = $font-weight-bold

$site-description-font-size       = 13px
$site-description-color           = $grey-dark
$site-description-margin-top      = 0
$site-description-align           = center

$site-state-item-count-font-size  = 16px
$site-state-item-name-font-size   = 13px
$site-state-item-name-color       = $grey-dark
$site-state-item-border-color     = $gainsboro

$toc-link-color                       = $grey-dim
$toc-link-border-color                = $grey-light
$toc-link-hover-color                 = black
$toc-link-hover-border-color          = black
$toc-link-active-color                = $sidebar-highlight
$toc-link-active-border-color         = $sidebar-highlight
$toc-link-active-current-color        = $sidebar-highlight
$toc-link-active-current-border-color = $sidebar-highlight


// Components
// --------------------------------------------------

// Button
$read-more-color              = $text-color
$read-more-bg-color           = white
$read-more-border-radius      = 2px
$btn-default-border-color     = $text-color
$btn-default-hover-color      = white
$btn-default-hover-bg         = $black-deep

// Full Image Tag
$full-image-width             = 118%
$full-image-margin-horizontal = -9%
$full-image-margin-vertical   = 0

// Back to top
$b2t-opacity                  = .6
$b2t-position-bottom          = -100px
$b2t-position-bottom-on       = 30px
```
## 结束语
&emsp;&emsp;文章到这里就结束了,对主题定制其实没有多难,只要有一些前端的基础,还是很简单的,主要是要找到你要改变的地方的类名,然后在找到对应的CSS中的内容就行了.
<font color= #D2691E size = 5>请大家尊重原创者版权，转载请标明出处:[www.wizardev.com](http://www.wizardev.com) 谢谢</font>
===