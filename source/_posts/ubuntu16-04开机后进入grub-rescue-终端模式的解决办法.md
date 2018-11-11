---
title: ubuntu16.04开机后进入grub rescue>终端模式的解决办法
date: 2017-08-19 08:44:55
tags:
- ubuntu
- linux
- 终端
categories: 
- linux
---
> 本来想着把Linux磁盘空间扩大一点，结果因为操作不当，开机后不能进入系统，进入了grub rescue>终端模式，进入这个模式的原因是系统找不到引导了，这时需要自己手动设置引导盘。

<!-- more -->

1.在grub rescue>终端模式下可以使用的命令很少，先使用ls命令找到ubuntu系统安装在哪个分区
```
grub rescue>ls
```
这时屏幕上会显示磁盘分区的信息，如下
```
(hd0),(hd0,msdos3),(hd0,msdos2),(hd0,msdos1),(hd0,msdos4),(hd0,msdos5),(hd0,msdos6)
```

2.这时输入一下命令
```
grub rescue>ls (hd0,msdosX)
```
X为数值1,2,3...，就是用ls命令看到的那些磁盘，你要一个一个试，如果找到正确的分区，就会显示分区的内容，否则会显示以下提示
```
error: unknown filesystem
```

3.通过步骤2，已经找到了正确的分区，这时依次输入一下命令来重新设置引导
```
set root=(hd0,msdosX)//X为你找到的正确的分区号
set prefix=(hd0,msdos8)/boot/grub
insmod normal //网上好多是输入insmod/boot/grub/normal.mod，这种对我并没用，反而会提示找不到normal.mod
normal
```

4.输入以上几个命令，就可以进入系统了，但进入系统扔会进入系统的终端界面，不会进入图形界面，这时需要输入以下命令来进行grub修复，否则下次进入系统仍然是grub rescue> 终端模式
```
sudo update-grub
sudo grub-install /dev/sda
```
<font color=red>注：</font>一定不要在/dev/sda加任何数字。

5.这时正确设置了引导，重新启动即可。

> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>


