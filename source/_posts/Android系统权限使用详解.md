---
title: Android系统权限使用详解
date: 2016-12-24 18:20:24
tags: Android permission
categories: Android
---
![](http://i.imgur.com/paKFeCP.jpg)
&emsp;&emsp;总有一些坚持会成为别人眼里的蹉跎，那并不意味着你有错，只需从容过好你的生活。
<!-- more -->
## Android权限分类 ##
&emsp;&emsp;安卓系统权限分为<font color="green">[正常权限](https://developer.android.google.cn/guide/topics/permissions/normal-permissions.html)</font>和<font color="red">危险权限</font>。

- <font color="green">正常权限</font>：指对用户隐私或其他应用操作风险影响很小的权限，例如，设置时区的权限就是正常权限。如果应用声明其需要正常权限，系统会自动向应用授予该权限。

- <font color="red">危险权限</font>：危险权限涵盖应用需要涉及用户隐私信息的数据或资源，或者可能对用户存储的数据或其他应用的操作产生影响的区域。例如，能够读取用户的联系人属于危险权限。

## 系统权限的申请 ##
### Android 5.1（API 级别 22）或更低版本系统权限的使用 ###
&emsp;&emsp;在API22以下，无论是正常权限或危险权限只要在清单文件中声明就行了。在软件安装时会向用户展示软件需要的权限，并一次请求所有的权限。如声明读取联系人的权限（属于危险权限），只要在清单文件中以以下方式声明即可

	<manifest xmlns:android="http://schemas.android.com/apk/res/android"
	package="com.android.app.myapp" >
	<uses-permission android:name="android.permission.READ_CONTACTS"/>
	 />
	...
	</manifest>


### Android 6.0（API 级别 23）或以上版本系统权限的使用 ###
#### 正常权限的使用 ####
&emsp;&emsp;在API23（含23）以上，<font color="green">正常权限</font>只需要在清单文件中声明就好了，就像Android5.1或更低版本那样在清单文件中声明。
#### 危险权限的使用 ####
&emsp;&emsp;在Android 6.0（API 级别 23）或以上版本由于Google对android系统安全机制的优化，使用危险系统权限不仅需要在清单文件中声明，还要在运行时申请权限，可以按一下步骤获取危险权限

1. 在清单文件中声明。

		<manifest xmlns:android="http://schemas.android.com/apk/res/android"
      		package="com.android.app.myapp" >
    ​	<uses-permission android:name="android.permission.RECEIVE_SMS" />
    ​	<!-- 获取接收短信的权限 -->
	​	...
	​	</manifest>
2. 在需要获取权限的Activity中检查是否已经获取到需要的权限。
	​	
		//thisActivity指当前的Activity
	​	int permissionCheck = ContextCompat.checkSelfPermission(thisActivity,
    ​    Manifest.permission.RECEIVE_SMS);
以上代码的返回值有两个，如果当前Activity有权限，返回值为***PackageManager.PERMISSION_GRANTED***，如果没有权限，返回值为***PackageManager.PERMISSION_DENIED***。
3. 根据 2 的返回值进行权限的操作

		if (permissionCheck= PackageManager.PERMISSION_DENIED) {
	​	/**
	​	*  说明没有获取权限，这时你可以通过shouldShowRequestPermissionRationale方法，
	​	*  判断是否需要向用户解释，为什么需要此权限。如果应用之前请求过此权限但用户拒绝了请求，
	​	*  此方法将返回 true。如果用户在过去拒绝了权限请求，并在权限请求系统对话框中选择了
	​	*   Don't askagain 选项，此方法将返回 false。如果设备规范禁止应用具有该权限，
	​	*  此方法也会返回 false。
	​	*/
      		if(ActivityCompat.shouldShowRequestPermissionRationale(thisActivity,
    ​        Manifest.permission.RECEIVE_SMS)) {
	​	//进入此方法说明用户拒绝了请求
    ​    // 注意：此方法将会阻塞线程，等待用户的响应，因此你要进行异步操作
    ​	} else {

        // 说明用户在过去拒绝了权限请求或设备规范禁止应用具有该权限
	    //如果应用尚无所需的权限，则应用必须调用一个 requestPermissions() 方法，以请求适当的权限。
        ActivityCompat.requestPermissions(thisActivity,
                new String[]{Manifest.permission.RECEIVE_SMS},
                1);
      		 }
	​	}

> requestPermissions()方法有三个参数，第一个为当前的Activity，第二个是一个String数组，内容是要申请的权限，第三个参数是整形数，作为当前权限请求的标志，在onRequestPermissionsResult()方法中会用到。

4、处理权限请求

&emsp;&emsp;当用户响应时，系统将调用应用的 onRequestPermissionsResult() 方法，向其传递用户响应。你必须替换该方法，以了解是否已获得相应权限。例如，如果应用请求 RECEIVE_SMS 访问权限，你采用以下回调方法：

	@Override
	public void onRequestPermissionsResult(int requestCode,
	String permissions[], int[] grantResults) {
	switch (requestCode) {
	    case 1: {
	        // 如果请求被取消，则grantResults数组为空
	        if (grantResults.length > 0
	            && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
	
	            //说明获取到相应的权限
	
	        } else {
	
	            没有获取到权限，依赖权限的操作无法完成
	        }
	        return;
	   	 	}
		}
	}
> requestCode：是你刚才设置的请求标志
> String permissions[]：需要请求的权限
> grantResults：请求权限的返回值

## 简便使用权限 ##
&emsp;&emsp;在Android6.0以上请求危险权限时，我们不一定要在onRequestPermissionsResult()方法中做操作，只要我们在当前应用获取到了权限，就可以在任地方进行使用。因此，我们可以在Activity的onCreate()方法中申请权限获取，获取成功后，你的应用可以不必只在onRequestPermissionsResult()方法中执行需要权限的操作。
## 后记 ##
&emsp;&emsp;在系统权限上踩了不少坑，所以在这里进行一些总结。提醒大家遇到问题一定要去仔细阅读官方文档，因为好多你遇到的问题里面都有解释。
<font color=#d2691e size = 5>转载请注明出处：[www.wizardev.cn](http://www.wizardev.cn) </font>