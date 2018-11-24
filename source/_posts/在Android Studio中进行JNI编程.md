---
title: 在Android Studio中进行JNI编程
date: 2017-02-19 16:41:49
tags: 
- Android 
- JNI 
- AndroidStudio
categories: 
- Android
---
&emsp;&emsp;本文主要讲在Android Studio中进行JNI编程的步骤，不涉及编码及在代码中声明本地源文件，如有这方面需要，请自行查找。
<!-- more -->
> &emsp;&emsp;想过自己想要的生活，没有捷径，即便是努力了没有收获时，也不能放弃自己，只要每天在变得更好的路上，你就能看见更好的风景。

## 开始前的准备 ##
&emsp;&emsp;使用JNI时，你需要下载NDK和工具，具体下载的方法和需要的工具，你可以移步这里["NDK和工具下载"](https://developer.android.google.cn/ndk/guides/index.html)
## 在Android Studio中使用C/C++的方式 ##
### 直接创建支持C/C++的新项目 ###
&emsp;&emsp;创建支持原生代码的项目与创建任何其他 Android Studio 项目类似，不过前者还需要额外几个步骤：

1. 在向导的 Configure your new project 部分，选中 Include C++ Support 复选框。
2. 点击 Next。
3. 正常填写所有其他字段并完成向导接下来的几个部分。
4. 在向导的 Customize C++ Support 部分，您可以使用下列选项自定义项目：

- C++ Standard：使用下拉列表选择您希望使用哪种 C++ 标准。选择 Toolchain Default 会使用默认的 CMake 设置。
- Exceptions Support：如果您希望启用对 C++ 异常处理的支持，请选中此复选框。如果启用此复选框，Android Studio 会将 -fexceptions 标志添加到模块级 build.gradle 文件的 cppFlags 中，Gradle 会将其传递到 CMake。
- Runtime Type Information Support：如果您希望支持 RTTI，请选中此复选框。如果启用此复选框，Android Studio 会将 -frtti 标志添加到模块级 build.gradle 文件的 cppFlags 中，Gradle 会将其传递到 CMake。
8. 点击 Finish。

&emsp;&emsp;具体内容请移步这里[直接创建支持C/C++的新项目](https://developer.android.google.cn/studio/projects/add-native-code.html#new-project)
<font color = "red" size = 5>注：</font>**需要使用 Android Studio 2.2 或更高版本与 Android Plugin for Gradle 版本 2.2.0 或更高版本**
### 向现有项目添加 C/C++ 代码
#### 创建新的原生源文件
&emsp;&emsp;要在应用模块的主源代码集中创建一个包含新建原生源文件的 cpp/ 目录，请按以下步骤操作：
1. 从 IDE 的左侧打开 Project 窗格并从下拉菜单中选择 Project 视图。
2. 导航到<font color = "purple">您的模块</font> > src，右键点击 main 目录，然后选择 New > Directory。
3. 为目录输入一个名称（例如 cpp）并点击 OK。
4. 右键点击您刚刚创建的目录，然后选择 New > C/C++ Source File。
5. 为您的源文件输入一个名称，例如 native-lib。
6. 从 Type 下拉菜单中，为您的源文件选择文件扩展名，例如 .cpp。
7. 点击 Edit File Types ，您可以向下拉菜单中添加其他文件类型，例如 .cxx 或 .hxx。在弹出的 C/C++ 对话框中，从 Source Extension 和 Header Extension 下拉菜单中选择另一个文件扩展名，然后点击 OK。
8. 如果您还希望创建一个标头文件，请选中 Create an associated header 复选框。
9. 点击 OK。


#### 创建 CMake 构建脚本 ####
&emsp;&emsp;在Android Studio中默认使用CMake 构建脚本，如果您的项目使用 ndk-build，则不需要创建 CMake 构建脚本。提供一个指向您的 Android.mk 文件的路径，将 Gradle 关联到您的原生库.<br>
&emsp;&emsp;如果您的原生源文件还没有 CMake 构建脚本，则您需要自行创建一个并包含适当的 CMake 命令。CMake 构建脚本是一个纯文本文件，您必须将其命名为 <font color = "green">CMakeLists.txt</font>。

1. 从 IDE 的左侧打开 Project 窗格并从下拉菜单中选择 Project 视图。
2. 右键点击您的模块的根目录并选择 New > File。
> 注：您可以在所需的任意位置创建构建脚本。不过，在配置构建脚本时，原生源文件和库的路径将与构建脚本的位置相关。

3. 输入“CMakeLists.txt”作为文件名并点击 OK。<br>
&emsp;&emsp;现在，您可以添加 CMake 命令，对您的构建脚本进行配置。要指示 CMake 从原生源代码创建一个原生库，请将cmake_ minimum_ required() 和 add_library() 命令添加到您的构建脚本中：

	cmake_minimum_required(VERSION 3.4.1)
	add_library( 
	​		 # 要生成动态库的名称，可以自己设定
   ​          native-lib 

             # 设置这个库为公开的
             SHARED
    
             # 关联源码的路径
             src/main/cpp/native-lib.cpp )
&emsp;&emsp;使用 add_library() 向您的 CMake 构建脚本添加源文件或库时，Android Studio 还会在您同步项目后在 Project 视图下显示关联的标头文件。不过，为了确保 CMake 可以在编译时定位您的标头文件，您需要将 include_directories() 命令添加到 CMake 构建脚本中并指定标头的路径：


	add_library(...)
	
	# Specifies a path to native header files.
	include_directories(src/main/cpp/include/)
&emsp;&emsp;CMake 使用以下规范来为库文件命名：

&emsp;&emsp;lib*库名称*.so<br>
&emsp;&emsp;例如，如果您在构建脚本中指定“native-lib”作为共享库的名称，CMake 将创建一个名称为 libnative-lib.so 的文件。不过，在 Java 代码中加载此库时，请使用您在 CMake 构建脚本中指定的名称：
```
static {
    	System.loadLibrary(“native-lib”);
	}
```
#### 将 Gradle 关联到您的原生库
&emsp;&emsp;要将 Gradle 关联到您的原生库，您需要提供一个指向 CMake 或 ndk-build 脚本文件的路径。在您构建应用时，Gradle 会以依赖项的形式运行 CMake 或 ndk-build，并将共享的库封装到您的 APK 中。Gradle 还使用构建脚本来了解要将哪些文件添加到您的 Android Studio 项目中，以便您可以从 Project 窗口访问这些文件。如果您的原生源文件没有构建脚本，则需要先创建 CMake 构建脚本，然后再继续。<br>
&emsp;&emsp;将 Gradle 关联到原生项目后，Android Studio 会更新 Project 窗格以在 cpp 组中显示您的源文件和原生库，在 External Build Files 组中显示您的外部构建脚本。<br>
 <font color=red>注：更改 Gradle 配置时，请确保通过点击工具栏中的 Sync Project  应用更改。此外，如果在将 CMake 或 ndk-build 脚本文件关联到 Gradle 后再对其进行更改，您应当从菜单栏中选择 Build > Refresh Linked C++ Projects，将 Android Studio 与您的更改同步。</font>

&emsp;&emsp;您可以使用 Android Studio UI 将 Gradle 关联到外部 CMake 或 ndk-build 项目：
1. 从 IDE 左侧打开 Project 窗格并选择 Android 视图。
2. 右键点击您想要关联到原生库的模块（例如 app 模块），并从菜单中选择 Link C++ Project with Gradle。您应看到一个如图 4 所示的对话框。
3. 从下拉菜单中，选择 CMake 或 ndk-build。
- 如果您选择 CMake，请使用 Project Path 旁的字段为您的外部 CMake 项目指定 CMakeLists.txt 脚本文件。
- 如果您选择 ndk-build，请使用 Project Path 旁的字段为您的外部 ndk-build 项目指定 Android.mk 脚本文件。如果 Application.mk 文件与您的 Android.mk 文件位于相同目录下，Android Studio 也会包含此文件。
![使用 Android Studio 对话框关联外部 C++ 项目](http://i.imgur.com/jy8eg65.png)
图 使用 Android Studio 对话框关联外部 C++ 项目。
6. 点击 OK。

## 总结 ##
&emsp;&emsp;按上述步骤进行到这里，你已经可以使用Android Studio编写JNI程序了，总结步骤如下：

1. 创建新的源文件。
2. 创建 CMake 构建脚本。
3. 将 Gradle 关联到您的原生库。
4. 不要忘记在java文件中载入动态库文件。

> static {
    	System.loadLibrary(“native-lib”);
	}

## 后记 ##
&emsp;&emsp;由于本人技术有限，难免有一些错误和遗漏的地方，欢迎大家指正。<br>
&emsp;&emsp;<font color=#d2691e size = 5>转载请注明出处：[www.wizardev.cn](http://www.wizardev.cn) </font>

