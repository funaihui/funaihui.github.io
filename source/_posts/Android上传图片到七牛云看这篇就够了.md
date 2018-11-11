---
title: Android上传图片到七牛云看这篇就够了
date: 2017-08-13 15:54:21
tags:
- 七牛云 
- 图片 
- Android
categories: 
- Android
---
> 在开发中遇到需要将用户的头像上传到七牛云，折腾了好一阵子才搞定，于是，决定写篇博客记录一下，有这方面需求的开发者，可以作为参考。

<!-- more -->
## 搭建Android上传图片的环境
1. 在官网注册账号
2. 在Android Studio中集成官方的SDK
   - 这里我们不用下载，直接在Android Studio添加官方的依赖就行了，具体请看[这里](https://developer.qiniu.com/kodo/sdk/1236/android).


&emsp;&emsp;完成了上面两步，Android上传图片的环境就搭建好了。
## 上传图片
&emsp;&emsp;先看下官方的示例代码
```
//指定zone的具体区域 
//FixedZone.zone0   华东机房
//FixedZone.zone1   华北机房
//FixedZone.zone2   华南机房
//FixedZone.zoneNa0 北美机房

//自动识别上传区域 
//AutoZone.autoZone


//Configuration config = new Configuration.Builder()
//.zone(Zone.autoZone)
//.build();
//UploadManager uploadManager = new UploadManager(config);
data = <File对象、或 文件路径、或 字节数组>
String key = <指定七牛服务上的文件名，或 null>;
String token = <从服务端SDK获取>;
uploadManager.put(data, key, token,
    new UpCompletionHandler() {
        @Override
        public void complete(String key, ResponseInfo info, JSONObject res) {
            //res包含hash、key等信息，具体字段取决于上传策略的设置
             if(info.isOK()) {
                Log.i("qiniu", "Upload Success");
             } else {
                Log.i("qiniu", "Upload Fail");
                //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
             }
             Log.i("qiniu", key + ",\r\n " + info + ",\r\n " + res);
            }
        }, null);
```
现在，对以上代码需要的参数进行讲解
- data：就是你需要上传图片的路径，也就是你上传的图片放在手机的哪个位置。
- key：这个是你上传图片到七牛云之后的名称，如key你设置为2017813，则你将图片上传到七牛云之后，图片的名称就是2017813.
- token:这个就很重要了，如果这个错误，是不能成功将图片上传到七牛云的,官方建议token从服务器获取


> 该 SDK 未包含凭证生成相关的功能。开发者对安全性的控制应遵循安全机制中建议的做法，即客户端应向业务服务器每隔一段时间请求上传凭证，而不是直接在客户端使用 AccessKey / SecretKey 生成对应的<font color=green>凭证</font>。在客户端使用 SecretKey 会导致严重的安全隐患。

这里的<font color=green>凭证</font>就是上面代码中的token，这里为了讲的详细，就在本地生成token！
### 获取token
&emsp;&emsp;官方已经为我们提供了生成token的方法，可以在这里获取获取生成token的代码，[点击这里获取](https://github.com/qiniu/java-sdk/blob/master/src/main/java/com/qiniu/util/Auth.java?ref=developer.qiniu.com).上面的代码是在github中，如果直接复制，会缺少很多东西，想要完整的生成token的代码，可以在文章末尾获得，直接拷贝工程下的utils包中的代码即可。

&emsp;&emsp;在生成token时，需要AccessKey / SecretKey，AccessKey / SecretKey在注册之后就可以查看，登录自己的账号在个人中心--秘钥管理界面下查看，如下图
![](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_012.png)
### 上传图片到自己的七牛云
&emsp;&emsp;看下经过完善后的代码
```
private void uploadImg2QiNiu() {
        UploadManager uploadManager = new UploadManager();
        // 设置图片名字
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String key = "icon_" + sdf.format(new Date());
        String picPath = getOutputMediaFile().toString();
        Log.i(TAG, "picPath: " + picPath);
        //Auth.create(AccessKey, SecretKey).uploadToken("zhongshan-avatar")，这句就是生成token
        uploadManager.put(picPath, key, Auth.create(AccessKey, SecretKey).uploadToken("zhongshan-avatar"), new UpCompletionHandler() {
            @Override
            public void complete(String key, ResponseInfo info, JSONObject res) {
                // info.error中包含了错误信息，可打印调试
                // 上传成功后将key值上传到自己的服务器
                if (info.isOK()) {
                    Log.i(TAG, "token===" + Auth.create(AccessKey, SecretKey).uploadToken("photo"));
                    String headpicPath = "http://ot6991tvl.bkt.clouddn.com/" + key;
                    Log.i(TAG, "complete: " + headpicPath);
                }
                //     uploadpictoQianMo(headpicPath, picPath);
            }
        }, null);
```
<font color = red>注：</font>
>Auth.create(AccessKey,SecretKey).uploadToken("zhongshan-avatar")

这句就是生成token的代码，其中<font color= green>uploadToken("zhongshan-avatar")</font>里面的参数，是需要上传到自己的七牛云中的哪个位置，如下图
<center>
![](http://ot6991tvl.bkt.clouddn.com/%E9%80%89%E5%8C%BA_013.png)</center>
这里有两个存储空间，<font color= green>uploadToken("zhongshan-avatar")</font>中的参数就可以为这两个名称的其中一个。
经过以上的步骤，便可以将图片上传到到自己的七牛云中了。
## 结束语
&emsp;&emsp;下面的代码是完整的android工程，只需要将AccessKey / SecretKey换成你自己的就行了，就可以成功的将图片上传到你自己的七牛云中。
[点击这里获取完整的项目](https://github.com/funaihui/ImagePick)
> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>
