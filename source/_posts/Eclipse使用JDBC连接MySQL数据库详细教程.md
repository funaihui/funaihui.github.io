---
title: Eclipse使用JDBC连接MySQL数据库详细教程
date: 2016-09-06 18:06:49
tags: 
- Android 
- 支付 
- AndroidStudio
categories: 
- Android
---



> <font color="00CED1">前言：遇到问题不要退缩，因每解决一个问题你就离目标更近一步</font>

<!-- more -->
### 下载连接MySQL数据库的驱动
使用JDBC连接MySQL数据库的驱动为[Connentor/J](http://dev.mysql.com/downloads/connector/j/),需要下载什么版本可以参考下图。

![Connector/J版本相关知识](http://img.blog.csdn.net/20160906180301061)

下载完成之后需要解压到本地。
### 在Eclipse中引用jar包
在新建的Java工程上点击右键，Build Path --->Add External Archives.. 添加解压缩到本地的jar包。

![这里写图片描述](http://img.blog.csdn.net/20160906181557863)
### JDBC连接数据库步骤
1. 载入驱动
2. 连接数据库
### 连接数据库的注意事项
我们解压到本地的文件里面有官方关于使用JDBC连接数据库的文档，这里我们可以看一下官方的文档。下面是官方文档中的代码

```
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
// Notice, do not import com.mysql.cj.jdbc.*
// or you will have problems!
public class LoadDriver {
public static void main(String[] args) {
try {
// The newInstance() call is a work around for some
// broken Java implementations
Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
} catch (Exception ex) {
// handle the error
		}
	}
}
```
这里的`Class.forName("com.mysql.cj.jdbc.Driver").newInstance();`
是用于注册驱动，也就是*JDBC连接数据库步骤* 中的第一步。我们在Eclipse中运行正常，没有什么问题。下面是第二步连接数据库，我们这里也用官方文档中提供给我们的代码。代码如下

```
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
Connection conn = null;
...
try {
conn =
DriverManager.getConnection("jdbc:mysql://localhost/test?" +
"user=minty&password=greatsqldb");
// Do something with the Connection
...
} catch (SQLException ex) {
// handle any errors
System.out.println("SQLException: " + ex.getMessage());
System.out.println("SQLState: " + ex.getSQLState());
System.out.println("VendorError: " + ex.getErrorCode());
}
```
现在我们来看一下这段代码，其中也就一句
`DriverManager.getConnection("jdbc:mysql://localhost/test?" +
"user=minty&password=greatsqldb");`
这段代码是用于连接到数据库的，上面的**test**是我们自己的数据库，**user=minty** 是我们安装数据库使用的用户名，**password=greatsqldb** 是我们自己的数据库密码，现在我们把第一步与第二步一起在Eclipse中运行一下，代码如下

```
/**
 * URL是用于连接数据库的标识符
 * USER_NAME 是安装MySQL时使用的用户名
 * PASSWORD 是与用户名相对应的密码
 */
public class Jdbc {
	//mydb是我自己建的数据库
	//user=root 我自己数据库的用户名
	//password=wizardfu 我自己的数据库的密码
	public static final String URL = "jdbc:mysql://localhost/mydb?" +
			"user=root&password=wizardfu";
	public static void main(String[] args) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			DriverManager.getConnection(URL);
			System.out.println("成功加载MYSQL驱动");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
```
这里我们看一下运行结果
![这里写图片描述](http://img.blog.csdn.net/20160906184340109)
发现有警告，查了一下资料说是时区的问题，只要把上面的URl修改一下就好了，看一下修改后的URL
```
public static final String URL = "jdbc:mysql://localhost/mydb?serverTimezone=UTC"+"user=root&password=wizardfu";
```
我们再在Eclipse中运行一下，又发现出现了下面的警告
![这里写图片描述](http://img.blog.csdn.net/20160906185655721)
这里我把没有显示出来的警告粘贴出来，如下

> Tue Sep 06 18:53:24 CST 2016 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.

我们在上面的警告中发现一段话
> You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification

这里说需要设置 <font color="red">useSSL=false or set useSSL=true</font>
我们再次改变URL的代码，改变后的代码如下

```
public static final String URL = "jdbc:mysql://localhost/mydb?serverTimezone=UTC&useSSL=false&user=root&password=wizardfu";
```
再次运行一下，结果如下
![这里写图片描述](http://img.blog.csdn.net/20160906190540467)
好了，到此已经通过JDBC成功连接到MySQL数据库。连接的时候确实遇到不少麻烦，写下这篇文章希望大家少踩坑。




<font color= #D2691E size = 5>请大家尊重原创者版权，转载请标明出处: [www.wizardev.com](http://www.wizardev.com) 谢谢</font>



