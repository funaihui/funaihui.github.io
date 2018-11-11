---
title: 利用Android Studio在App中集成第三方支付
date: 2017-06-25 17:29:49
tags: 
- Android 
- 支付 
- AndroidStudio
categories: 
- Android
---
> <font color="green">觉得自己好久没有写博客了，看了一下时间，果然好久没写了。吓得我赶紧写篇博客压压惊。</font><br>

<!-- more -->
## 第三方支付的选择 ##
&emsp;&emsp;目前主流的第三方支付平台，有以下几种：

 - 支付宝
 - 微信支付
 - 百度钱包
 - 网银支付
 - 第三方聚合支付

以上几种支付平台，除了*第三方聚合支*付以外，其他几个在使用时，都是需要公司信息的，这对一些个人开发者以及初学者就造成了一些困难，还好，有第三方聚合支付，它可以提供测试的接口给开发者，这里我们就用第三方聚合支付的测试接口进行付款。
&emsp;&emsp;我知道的第三方聚合支付主要有：

 1. Ping++：https://pingxx.com
 2. Bmob   :     http://www.bmob.cn

这里，我用的是Ping++，至于Bmob大家可以自己研究，不过料想原理应该差不多。
## 使用前的准备工作 ##
&emsp;&emsp;在使用之前，我们需要到Ping++的官网完成注册，注册之后，就有了一个用于测试的Test Secret Key ，可以在使用者的企业设置下面发现Test Secret Key，如下图
![图片1](http://img.blog.csdn.net/20170625070938118?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
&emsp;&emsp;我们可以在官网的首页，开发者中心下载集成的SDK。
## 开始集成 ##
### 文件介绍
&emsp;&emsp;下载SDK后，可以在～/pingpp-android/路径下发现一个lib文件夹，打开后还有三个文件夹，分别为一下三个文件夹
![图片2](http://img.blog.csdn.net/20170625072210530?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
这里我们只需要用到前两就行了，第一个文件夹是集成百度钱包需要用到的，第二个是集成其他的支付方式需要用到的。
### 集成方式 
&emsp;&emsp;在Android Studio集成第三方SDK有两种方式，第一种就是直接在自己的app所在的文件中进行集成，第二种则是新建一个性质为Library的Module，将第三方的SDK放在新建的Module中，然后在自己的app中引入。
&emsp;&emsp;为了不让自己的App过于臃肿以及以后修改方便，这里采用第二种集成方式。我们可以按一下步骤在Android Studio新建一个Module
![图片3](http://img.blog.csdn.net/20170625074814979?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
![图片4](http://img.blog.csdn.net/20170625075004670?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
这样我们就建立了一个性质为Library的Module。

&emsp;&emsp;下面我们需要做的工作就是把pingpp文件家中的东西搬运过来。
<font color="red">注意：这里要把文件结构试图改为Project视图，不然看不见libs文件夹。</font>切换方式如下
![图片5](http://img.blog.csdn.net/20170625080959995?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)</br>
我们把 pingpp/libs下的jar包放进libs目录下，放进去后应该是这种结构
![图片6](http://img.blog.csdn.net/20170625081145615?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)</br>
这里我们需要在Android Studio中新建一个jniLibs文件夹，新建jniLibs文件夹步骤如下图
![图片7](http://img.blog.csdn.net/20170625081647746?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)</br>
这种方式新建以后是一个名为cpp的文件夹，我们只要把它的名字改为jniLibs即可，然后把/pingpp/libs/文件夹中除了jar文件，其他的文件夹放进jniLibs文件夹即可就行了，放进后的文件结构应该如下图所示</br>
![图片8](http://img.blog.csdn.net/20170625082206578?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)</br>
这里我们只要将以下四个文件夹中的内容搬运进来就行了，必要时再替换一下清单文件。
![图片9](http://img.blog.csdn.net/20170625082750380?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast) </br>
### 添加依赖
&emsp;&emsp;我们只要把刚才新建的module引入到自己的app中就行了，在自己的app上右键选中下图的选项</br>
<center>![图片10](http://img.blog.csdn.net/20170625083305273?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)</center>
打开一下界面选中如下选项（红框内的），把新建的Module添加进去就行了。
<center>![图片11](http://img.blog.csdn.net/20170625083733754?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZm5oZmlyZV83MDMw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)</center>
最好，我们把新建的Module中Gradle中引用的以下两个依赖删除，因为在自己的app已经引入了。

> compile 'com.android.support:appcompat-v7:26.+'
    testCompile 'junit:junit:4.12'

添加bdwallet_pay_sdk也按以上方式进行即可。
### 在清单文件中添加权限及Activity
&emsp;&emsp;添加权限及Activity可按[官方指导文件](https://www.pingxx.com/docs/client/sdk/android)进行操作。
## 开始使用
&emsp;&emsp;以下代码是调用第三方支付

```
class PaymentTask extends AsyncTask<PaymentRequest, Void, String> {

        @Override
        protected void onPreExecute() {
            //按键点击之后的禁用，防止重复点击
            mCreateOrder.setEnabled(false);
        }

        @Override
        protected String doInBackground(PaymentRequest... pr) {

            PaymentRequest paymentRequest = pr[0];
            String data = null;
            try {
                JSONObject object = new JSONObject();
                object.put("channel", paymentRequest.channel);
                object.put("amount", paymentRequest.amount);
                String json = object.toString();
                //向Your Ping++ Server SDK请求数据
                data = postJson(CHARGE_URL, json);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return data;
        }

        /**
         * 获取charge
         *
         * @param urlStr charge_url
         * @param json   获取charge的传参
         * @return charge
         * @throws IOException
         */
        private String postJson(String urlStr, String json) throws IOException {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(8000);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.getOutputStream().write(json.getBytes());

            if (conn.getResponseCode() == 200) {
                BufferedReader
                        reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                return response.toString();
            }
            return null;
        }

        /**
         * 获得服务端的charge，调用ping++ sdk。
         */
        @Override
        protected void onPostExecute(String data) {
            if (null == data) {
                showMsg("请求出错", "请检查URL", "URL无法获取charge");
                return;
            }
            Log.d("charge", data);

            //除QQ钱包外，其他渠道调起支付方式：
            //参数一：Activity  当前调起支付的Activity
            //参数二：data  获取到的charge或order的JSON字符串
            Pingpp.createPayment(MainActivity.this, data);

            //QQ钱包调用方式
            //参数一：Activity  当前调起支付的Activity
            //参数二：data  获取到的charge或order的JSON字符串
            //参数三：“qwalletXXXXXXX”需与AndroidManifest.xml中的scheme值一致
            //Pingpp.createPayment(ClientSDKActivity.this, data, "qwalletXXXXXXX");
        }

    }
```
参考代码请[点击这里](https://github.com/funaihui/pay)

## 结束语
&emsp;&emsp;<font color = "green" size = "5">转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>



