css 填坑常用代码分享
一. css 2.x code
1. 文字换行
复制代码
/*强制不换行*/
white-space:nowrap;
/*自动换行*/
word-wrap: break-word;
word-break: normal;
/*强制英文单词断行*/
word-break:break-all;
复制代码
2. 两端对齐
text-align:justify;text-justify:inter-ideogra

3. 去掉Webkit(chrome)浏览器中input(文本框)或textarea的黄色焦点框
http://www.cnblogs.com/niao/archive/2012/09/07/2674511.html
input,button,select,textarea{ outline:none;}
textarea{ font-size:13px; resize:none;}
http://www.tuicool.com/articles/EZ777n
去掉chrome记住密码后自动填充表单的黄色背景

4. ie6: position:fixed
.fixed-top /* position fixed Top */{position:fixed;bottom:auto;top:0; }
* html .fixed-top /* IE6 position fixed Top */{position:absolute;bottom:auto;top:expression(eval(document.documentElement.scrollTop));}
*html{background-image:url(about:blank);background-attachment:fixed;}

5. clearfix
复制代码
.clearfix:after{visibility:hidden;display:block;font-size:0;content:" ";clear:both;height:0;}
.clearfix{display:inline-block;}
html[xmlns] .clearfix{display:block;}
* html .clearfix{height:1%;}
.clearfix{*zoom: 1;}
.clearfix:after{clear:both;display:table;content:"”;}
.clearfix{overflow:hidden;_zoom:1;}
复制代码
http://www.daqianduan.com/3606.html

6. seperate-table
.tab{border-collapse:separate;border:1px solid #e0e0e0;}
.tab th,.tab td{padding:3px;font-size:12px;background:#f5f9fb;border:1px solid;border-color:#fff #deedf6 #deedf6 #fff;}
.tab th{background:#edf4f0;}
.tab tr.even td{background:#fff;}

复制代码
<table class="tab" width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <th>111</th>
        <td>222</td>
    </tr>
    <tr>
        <th>111</th>
        <td>222</td>
    </tr>
</table>
复制代码
7. 光标大小：
http://hi.baidu.com/jiuyuefenglin/item/dee35b080366f11cebfe3862

8. min-height: 最小高度兼容代码
.minheight500{min-height:500px;height:auto !important;height:500px;overflow:visible;}
9. 鼠标不允许点击：
cursor:not-allowed;
10. mac font: osx平台字体优化
font-family:"Hiragino Sans GB","Hiragino Sans GB W3",'微软雅黑';
11. 省略号：
.ellipsis{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
二. css 3 code
1. 渐变：
.a{background:-webkit-gradient(linear,left top,left bottom,from(#69bdf9),to(#4aa7e8));background:-moz-linear-gradient(top,#67bcf8,#3b96d6);background:-o-linear-gradient(top,#67bcf8,#3b96d6);background:linear-gradient(top,#67bcf8,#3b96d6);}

2.投影：
.b{box-shadow:inset 1px -1px 0 #f1f1f1;text-shadow:1px 1px 0px #630;}
filter:progid:DXImageTransform.Microsoft.gradient(enabled='true',startColorstr='#99000000',endColorstr='#99000000');background:rgba(0,0,0,.6);
background:rgba(0,0,0,0.5);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#50000000',endColorstr='#50000000')\9;
看哪个startColorstr和endColorstr，一共8位，后6位是RGB的颜色代码，前两位是16进制的
比如60%透明，就是256x0.6=154，再换算成16进制=9A
background-image:-ms-linear-gradient(top, #fff, #ddd); ie10渐变
http://www.iefans.net/ie10-yulanban-css3-jianbian/
alpha透明兼容代码生成：
http://leegorous.net/tools/bg-alpha.html

16进制的转换
http://www.zhangxinxu.com/wordpress/2010/05/rgba%E9%A2%9C%E8%89%B2%E4%B8%8E%E5%85%BC%E5%AE%B9%E6%80%A7%E7%9A%84%E5%8D%8A%E9%80%8F%E6%98%8E%E8%83%8C%E6%99%AF%E8%89%B2/
透明兼容
3. search占位
http://www.qianduan.net/search-box-style-custom-webkit.html
复制代码
::-webkit-input-placeholder {}
::-moz-input-placeholder {}
input:focus::-webkit-input-placeholder { color: transparent; }
-webkit-appearance:none;  google边框去除
input[type="search"]{-webkit-appearance:textfield;} // 去除chrome默认样式
http://i.wanz.im/2011/02/04/remove_border_from_input_type_search/
http://blog.csdn.net/do_it__/article/details/6789699
line-height: normal; /* for non-ie */
line-height: 22px\9; /* for ie */
复制代码
4.
title 换行：&#13;
5. 渐变
复制代码
background: #bde25e; /* Old browsers */
background: -moz-linear-gradient(top, #bde25e 2%, #8bb31d 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(2%,#bde25e), color-stop(100%,#8bb31d)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, #bde25e 2%,#8bb31d 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, #bde25e 2%,#8bb31d 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top, #bde25e 2%,#8bb31d 100%); /* IE10+ */
background: linear-gradient(to bottom, #bde25e 2%,#8bb31d 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#bde25e', endColorstr='#8bb31d',GradientType=0 ); /* IE6-9 */
 @media screen and (max-width:1220px) and (min-width:1151px) {
    #wrapper {font-size:15px;}
}
复制代码
http://www.colorzilla.com/gradient-editor/
有全部浏览器的兼容代码生成

http://segmentfault.com/a/1190000000362621
CSS 实现 textArea 的 placeholder 换行

6.阻止默认事件
pointer-events:none;
7. 变灰 gray:
复制代码
html{
filter: grayscale(100%);
-webkit-filter: grayscale(100%);
-moz-filter: grayscale(100%);
-ms-filter: grayscale(100%);
-o-filter: grayscale(100%);
filter: url("data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\'><filter id=\'grayscale\'><feColorMatrix type=\'matrix\' values=\'0.3333 0.3333 0.3333 0 0 0.3333 0.3333 0.3333 0 0 0.3333 0.3333 0.3333 0 0 0 0 0 1 0\'/></filter></svg>#grayscale");
filter:progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);
-webkit-filter: grayscale(1);
}
复制代码
8. firefox 阻止选中：
-moz-user-focus:ignore;-moz-user-input:disabled;-moz-user-select:none;

9. 箭头
display:block;border:solid transparent;line-height: 0;width:0; height:0;border-top:solid #0288ce;border-width:8px 6px 0 6px;
border-style:solid; border-width:7px; border-color:transparent transparent transparent #ff7020;

position:absolute;top: 0;left: 0;border-width:20px;border-style:solid;border-color:#d1ddde transparent transparent #d1ddde;

ie6 bug测试，把border-style设为dashed.
10. 取消textarea右下角可拖动手柄：
resize:none

 11. 取消chrome form表单的聚焦边框：
input,button,select,textarea{outline:none}
textarea{resize:none}

12. 取消a链接的黄色边框：
a{-webkit-tap-highlight-color:rgba(0,0,0,0);}

13. 渐变
filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr=#ef6464, endColorstr= #eb4141);/*IE<9>*/
-ms-filter: "progid:DXImageTransform.Microsoft.gradient (GradientType=0, startColorstr=#ef6464, endColorstr=#eb4141)";/*IE8+*/
14.chrome字体缩小:
.chrome_adjust { font-size: 9px; -webkit-transform: scale(0.75); }

15. webkit 水平居中：
 display:-webkit-box;-webkit-box-pack:center; -webkit-box-align: center;

16. 取消chrome 搜索x提示：
复制代码
 input[type=search]::-webkit-search-decoration,
input[type=search]::-webkit-search-cancel-button,
input[type=search]::-webkit-search-results-button,
input[type=search]::-webkit-search-results-decoration {
display: none;
}
复制代码

17. autofill:
http://stackoverflow.com/questions/2338102/override-browser-form-filling-and-input-highlighting-with-html-css
复制代码
input:-webkit-autofill {-webkit-box-shadow: 0 0 0px 1000px white inset;}
input:-webkit-autofill,
textarea:-webkit-autofill,
select:-webkit-autofill {
    -webkit-box-shadow: 0 0 0 1000px white inset;
}
autocomplete="off"
复制代码

18. 手机版本网页a标记虚线框问题
a:focus { outline:none; -moz-outline:none; }

19. 焦点去除背景：
-webkit-tap-highlight-color: rgba(255, 255, 255, 0);
-webkit-tap-highlight-color: transparent;  // i.e. Nexus5/Chrome and Kindle Fire HD 7''

20. placeholder占位符颜色自定义
input:-moz-placeholder { color: #369; }
::-webkit-input-placeholder { color:#369; }
