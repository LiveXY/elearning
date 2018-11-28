css 填坑常用代码分享
一. css 2.x code
统一浏览器样式：https://github.com/necolas/normalize.css
样式的优先级：内联式 > 嵌入式 > 外部式 就近原则
块级元素 行内元素
```
块级元素：div  , p  , form,   ul,  li ,  ol, dl,    form,   address,  fieldset,  hr, menu,  table
行内元素：span,   strong,   em,  br,  img ,  input,  label,  select,  textarea,  cite
http://www.cnblogs.com/Kampfer/archive/2010/08/14/1799766.html
```
window body box 层级关系 box盒子模型/box-flex弹性盒子模型/Grid布局
```
https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes
http://www.zhangxinxu.com/wordpress/2010/12/css-box-flex%E5%B1%9E%E6%80%A7%EF%BC%8C%E7%84%B6%E5%90%8E%E5%BC%B9%E6%80%A7%E7%9B%92%E5%AD%90%E6%A8%A1%E5%9E%8B%E7%AE%80%E4%BB%8B/
https://segmentfault.com/a/1190000006559564
http://blog.csdn.net/hj7jay/article/details/70670467
```
position的relative,absolute,static,fixed区别：
```
static：默认值
relative：生成相对定位的元素，通过top,bottom,left,right的设置相对于其正常位置进行定位。可通过z-index进行层次分级。
absolute：生成绝对定位的元素，相对于 static 定位以外的第一个父元素进行定位。元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定。可通过z-index进行层次分级。
fixed：生成绝对定位的元素，相对于浏览器窗口进行定位。元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定。可通过z-index进行层次分级。
```
选择器
```
元素选择器 html {}
分组选择器 h2,p{}
类/ID选择器 .class,#id {}
属性选择器 *[title=''] {} p[class~=''] {}
后代选择器 h1 em {}
子元素选择器 h1 > strong {}
相邻兄弟选择器 h1 + p {}
兄弟选择器 p~p{}

```
1.文字换行
```
/*强制不换行*/
white-space:nowrap;
/*自动换行*/
word-wrap: break-word;
word-break: normal;
/*强制英文单词断行*/
word-break:break-all;
```
2. 两端对齐
```
text-align:justify;text-justify:inter-ideogra
```
3. 去掉Webkit(chrome)浏览器中input(文本框)或textarea的黄色焦点框
```
http://www.cnblogs.com/niao/archive/2012/09/07/2674511.html
input,button,select,textarea{ outline:none;}
http://www.tuicool.com/articles/EZ777n
去掉chrome记住密码后自动填充表单的黄色背景
input:-webkit-autofill {background-color:#FAFFBD;background-image:none; color:#000;}
input文本框是纯色背景的:-webkit-box-shadow:0 0 0px 1000px white inset;
form标签上直接关闭了表单的自动填充功能：autocomplete="off"
取消textarea的拖动改变大小的功能：
textarea{resize:none}
```
4. ie6: position:fixed
```
.fixed-top /* position fixed Top */{position:fixed;bottom:auto;top:0; }
* html .fixed-top /* IE6 position fixed Top */{position:absolute;bottom:auto;top:expression(eval(document.documentElement.scrollTop));}
*html{background-image:url(about:blank);background-attachment:fixed;}
```
5. clearfix
```
.clearfix:after{visibility:hidden;display:block;font-size:0;content:" ";clear:both;height:0;}
.clearfix{display:inline-block;}
html[xmlns] .clearfix{display:block;}
* html .clearfix{height:1%;}
.clearfix{*zoom: 1;}
.clearfix:after{clear:both;display:table;content:"”;}
.clearfix{overflow:hidden;_zoom:1;}
```
http://www.daqianduan.com/3606.html
6. seperate-table
```
.tab{border-collapse:separate;border:1px solid #e0e0e0;}
.tab th,.tab td{padding:3px;font-size:12px;background:#f5f9fb;border:1px solid;border-color:#fff #deedf6 #deedf6 #fff;}
.tab th{background:#edf4f0;}
.tab tr.even td{background:#fff;}
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
```
7. 光标大小：http://hi.baidu.com/jiuyuefenglin/item/dee35b080366f11cebfe3862
8. min-height: 最小高度兼容代码
.minheight500{min-height:500px;height:auto !important;height:500px;overflow:visible;}
9. 鼠标不允许点击：
cursor:not-allowed;
pointer-events: none;
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
::-webkit-input-placeholder {}
::-moz-input-placeholder {}
input:focus::-webkit-input-placeholder { color: transparent; }
-webkit-appearance:none; ios 边框去除 submit按钮显示圆角问题
input[type="search"]{-webkit-appearance:textfield;} // 去除chrome默认样式
http://i.wanz.im/2011/02/04/remove_border_from_input_type_search/
http://blog.csdn.net/do_it__/article/details/6789699
line-height: normal; /* for non-ie */
line-height: 22px\9; /* for ie */
4.title 换行：&#13;
5. 渐变
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
http://www.colorzilla.com/gradient-editor/
有全部浏览器的兼容代码生成
http://segmentfault.com/a/1190000000362621
CSS 实现 textArea 的 placeholder 换行
6.阻止默认事件
pointer-events:none;
e.stopPropagation();
e.preventDefault();
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
10. 取消textarea右下角可拖动手柄：resize:none
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
div 水平居中：margin: 0 auto;
16. 取消chrome 搜索x提示：
input[type=search]::-webkit-search-decoration,
input[type=search]::-webkit-search-cancel-button,
input[type=search]::-webkit-search-results-button,
input[type=search]::-webkit-search-results-decoration {
display: none;
}
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
18. 手机版本网页a标记虚线框问题
a:focus { outline:none; -moz-outline:none; }
19. 焦点去除背景：
-webkit-tap-highlight-color: rgba(255, 255, 255, 0);
-webkit-tap-highlight-color: transparent;  // i.e. Nexus5/Chrome and Kindle Fire HD 7''
20. placeholder占位符颜色自定义
input:-moz-placeholder { color: #369; }
::-webkit-input-placeholder { color:#369; }
解决UIWebView旋转成横屏后字体会放大的策略
-webkit-text-size-adjust: none;
-webkit-font-smoothing: none;
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=0”>
html,body{-webkit-touch-callout: none;}
禁用、禁止 UIWebView 里面的链接长按弹出效果
21.渐变
.grid aside.bottom {
    bottom: 0;
    text-align: left;
    background: -moz-linear-gradient(top,rgba(16,27,30,0) 0,rgba(12,2,2,1) 90%);
    background: -webkit-gradient(linear,left top,left bottom,color-stop(0%,rgba(16,27,30,0)),color-stop(90%,rgba(12,2,2,1)));
    background: -webkit-linear-gradient(top,rgba(16,27,30,0) 0,rgba(12,2,2,1) 90%);
    background: -o-linear-gradient(top,rgba(16,27,30,0) 0,rgba(12,2,2,1) 90%);
    background: -ms-linear-gradient(top,rgba(16,27,30,0) 0,rgba(12,2,2,1) 90%);
    background: linear-gradient(to bottom,rgba(16,27,30,0) 0,rgba(12,2,2,1) 90%);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#00101b1e',endColorstr='#0c0202',GradientType=0);
}
.page-header {
    color: #fff;
    text-align: center;
    background-color: #159957;
    background-image: linear-gradient(120deg, #155799, #159957);
}
.btn {
    display: inline-block;
    margin-bottom: 1rem;
    color: rgba(255, 255, 255, 0.7);
    background-color: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.2);
    border-style: solid;
    border-width: 1px;
    border-radius: 0.3rem;
    transition: color 0.2s, background-color 0.2s, border-color 0.2s;
}
-webkit-font-smoothing: antialiased;
.grad_top {
    background: -webkit-gradient(linear, 0 0, 0 100%, from(#fff), to(rgba(255, 255, 255, 0)));
    background: -moz-linear-gradient(top, #fff, rgba(255, 255, 255, 0));
    background: -o-linear-gradient(top, #fff, rgba(255, 255, 255, 0));
    background: linear-gradient(top, #fff, rgba(255, 255, 255, 0));
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#ffffff, endColorstr=#00ffffff, GradientType=0);
}
.grad_bottom {
    background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(255, 255, 255, 0)), to(#fff));
    background:-moz-linear-gradient(top, rgba(255, 255, 255, 0), #fff);
    background:-o-linear-gradient(top, rgba(255, 255, 255, 0), #fff);
    background: linear-gradient(top, rgba(255, 255, 255, 0), #fff);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#00ffffff, endColorstr=#ffffff, GradientType=0);
    bottom: 0;
}
pointer-events:none;
background-image: linear-gradient(135deg, #f35 0%, #f93 100%);
background: -webkit-linear-gradient(top,#f4f4f4 50%,#fff 50%);
    background: -o-linear-gradient(top,#f4f4f4 50%,#fff 50%);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#f4f4f4,endColorstr=#ffffff,gradientType=0);
background: -webkit-linear-gradient(left,#f4f4f4 50%,#fff 50%);
    background: -o-linear-gradient(left,#f4f4f4 50%,#fff 50%);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#f4f4f4,endColorstr=#ffffff,gradientType=1);

渐变隐藏
.summary:after {
    position: absolute;
    right: 0;
    bottom: 0;
    display: block;
    width: 160px;
    height: 20px;
    content: '';
    background: -webkit-linear-gradient(left, rgba(255,255,255,0), #fff 96%);
    background: -webkit-gradient(linear, left top, right top, from(rgba(255,255,255,0)), color-stop(96%, #fff));
    background: linear-gradient(to right, rgba(255,255,255,0), #fff 96%);
}

字体大小：
fontSize=20*((document.documentElement.clientWidth || document.body.clientWidth)/320)

垂直局中1：利用table
.pdiv { dispaly:table;width:100%;height:100%; }
.sdiv { dispaly:table-cell;vertical-align:middle;text-align:center }
垂直局中2：利用flex-box
.pdiv {display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-moz-flex;display:-ms-flexbox;display:flex;-webkit-box-pack:center;-ms-flex-pack:center;-webkit-justify-content:center;-moz-justify-content:center;justify-content:center;-webkit-box-align:center;-ms-flex-align:center;-webkit-align-items:center;-moz-align-items:center;align-items:center;}
.sdiv {display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-moz-flex;display:-ms-flexbox;display:flex;-webkit-box-direction:normal;-webkit-box-orient:vertical;-webkit-flex-direction:column;-moz-flex-direction:column;-ms-flex-direction:column;flex-direction:column;    -moz-transform: scale(-1, 1);-ms-transform: scale(-1, 1);-o-transform: scale(-1, 1);-webkit-transform: scale(-1, 1);transform: scale(-1, 1);transition: opacity 1s;}
http://blog.csdn.net/lzqial1987/article/details/78747662

全屏显示
width:100%;max-width:100%;height:100%;max-height:100%;object-fit:cover;

帮助提示萌层
.hl-in {box-shadow: 0 0 20px 0 #fff0d5,0 0 0 2px #f1a325,0 0 0 2000px rgba(0,0,0,.2)!important;}

放大1.1倍
-webkit-transform: scale(1.1); -ms-transform: scale(1.1); transform: scale(1.1) !important;

阴影：box-shadow: 2.5pt 2.5pt 1.5pt #595959;
背景色动画渐变：transition: background-color 0.25s linear 0s;

文本框
.form-control {
  display: block;
  width: 100%;
  height: 34px;
  padding: 6px 12px;
  font-size: 14px;
  line-height: 1.42857143;
  color: #555;
  background-color: #fff;
  background-image: none;
  border: 1px solid #ccc;
  border-radius: 4px;
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
          box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
  -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
       -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
          transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
}
.form-control:focus {
  border-color: #66afe9;
  outline: 0;
  -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6);
          box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6);
}
.form-control::-moz-placeholder {
  color: #999;
  opacity: 1;
}
.form-control:-ms-input-placeholder {
  color: #999;
}
.form-control::-webkit-input-placeholder {
  color: #999;
}
.form-control::-ms-expand {
  background-color: transparent;
  border: 0;
}
textarea.form-control {
  height: auto;
}
.input-sm {
  height: 30px;
  padding: 5px 10px;
  font-size: 12px;
  line-height: 1.5;
  border-radius: 3px;
}

下拉列表
.mastfoot select {
  border: 1px solid #6D6D6D;
  border-radius: 4px;
  font-size: 13px;
  line-height: 14px;
  color: #FFF;
  background-color: transparent;
  padding: 7px 20px 7px 6px;
  min-width: 130px;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  background-image: url("data:image/svg+xml;utf8,<svg fill='white' width='20' height='14' viewBox='0 0 8 14' xmlns='http://www.w3.org/2000/svg'><path d='M8 5.5q0 0.203-0.148 0.352l-3.5 3.5q-0.148 0.148-0.352 0.148t-0.352-0.148l-3.5-3.5q-0.148-0.148-0.148-0.352t0.148-0.352 0.352-0.148h7q0.203 0 0.352 0.148t0.148 0.352z' /></svg>");
  background-repeat: no-repeat;
  background-position-x: 100%;
  background-position-y: 7px;
  cursor: pointer;
}
.mastfoot select:hover,
.mastfoot select:focus {color: #D1D1D1; }
.mastfoot select option { color: #333; }

上下动画
.hero-octonaut{position:absolute;top:100px;left:calc(50% - 380px);animation:hero-octonaut 2s alternate ease-in-out infinite;will-change:transform;-webkit-user-select:none;user-select:none;}
@keyframes hero-octonaut{0%{transform:translateY(-8px)}100%{transform:translateY(8px)}}

转圈动画
.hero-logo-circle{position:absolute;left:0;top:0;animation:hero-logo-circle 1s linear infinite;will-change:transform}
.hero-logo-circle:nth-child(1){animation-duration:30s}
.hero-logo-circle:nth-child(2){animation-duration:40s}
.hero-logo-circle:nth-child(3){animation-duration:50s}
.hero-logo-circle:nth-child(4){animation-duration:60s}
.hero-logo-circle:nth-child(5){animation-duration:70s}
.hero-logo-circle:nth-child(6){animation-duration:80s}
.hero-logo-circle:nth-child(7){animation-duration:90s}
.hero-logo-circle:nth-child(8){animation-duration:100s}
.hero-logo-circle:nth-child(9){animation-duration:110s}
.hero-logo-circle:nth-child(10){animation-duration:120s}
@keyframes hero-logo-circle{100%{transform:rotate(1turn)}}

.welcome .welcome-bg{position:absolute}
.welcome .welcome-bg--screenshot{bottom:50%;right:50%;margin-bottom:-244px;margin-right:40px;width:780px;height:488px;border-radius:5px;box-shadow:0 20px 30px rgba(0,0,0,0.5);transition:filter 2s}
.welcome .welcome-bg--screenshot:hover{filter:none}
发黄
.section--realtime .welcome-bg--screenshot{filter:brightness(0.75) contrast(1) sepia(0.7) hue-rotate(-5deg) saturate(3.5);}
发紫
.section--ide .welcome-bg--screenshot{left:50%;margin-left:40px;filter:brightness(0.7) contrast(0.8) sepia(1) hue-rotate(160deg) saturate(3)}
发白
.section--github .welcome-bg--screenshot{filter:brightness(0.7) contrast(1) sepia(1) hue-rotate(115deg) saturate(1.5)}

<link rel="stylesheet" media="all and (orientation:portrait)" href="portrait.css">    // 竖放加载
<link rel="stylesheet" media="all and (orientation:landscape)"href="landscape.css">   // 横放加载
竖屏时使用的样式
<style media="all and (orientation:portrait)" type="text/css">
  #landscape { display: none; }
</style>
//横屏时使用的样式
<style media="all and (orientation:landscape)" type="text/css">
  #portrait { display: none; }
</style>

OSX10.10和iOS8.0支持半像素了
@media (-webkit-min-device-pixel-ratio: 2) {
    .one-pixel-border {
        border-width: 0.5px;
    }
}

当横屏时，fixed元素不能自适应横屏的宽度
解决问题的关键就是：fixed元素内部必须嵌套一个position:absolute元素，用来装载内容，目的就是为了让内容脱离fixed文档流，屏蔽一些fixed的坑

一个placeholder自适应bug，页面中使用<input>标签并且有属性placeholder，在页面横屏再转回竖屏时，会导致页面无法自适应，无论是android还是ios都会中招。
解决方法是，在<input>外层容器中加overflow:hidden，这个bug我没有截图，大家可以自测。

①“盒模型”的具体描述性质的包围盒块内容，包括边界，填充等等。

  -webkit-border-bottom-left-radius: radius;
  -webkit-border-top-left-radius: horizontal_radius vertical_radius;
  -webkit-border-radius: radius;      //容器圆角
  -webkit-box-sizing: sizing_model; 边框常量值：border-box/content-box
  -webkit-box-shadow: hoff voff blur color; /*容器阴影（参数分别为：水平X 方向偏移量；垂直Y方向偏移量；高斯模糊半径值；阴影颜色值）*/
  -webkit-margin-bottom-collapse: collapse_behavior; /*常量值：collapse/discard/separate*/
  -webkit-margin-start: width;
  -webkit-padding-start: width;
  -webkit-border-image: url(borderimg.gif) 25 25 25 25 round/stretch round/stretch;
  -webkit-appearance: push-button;   /*内置的CSS 表现，暂时只支持push-button*/
②“视觉格式化模型”描述性质，确定了位置和大小的块元素。

direction: rtl
unicode-bidi: bidi-override; 常量：bidi-override/embed/normal
③“视觉效果”描述属性，调整的视觉效果块内容，包括溢出行为，调整行为，能见度，动画，变换，和过渡。

clip: rect(10px, 5px, 10px, 5px)
resize: auto; 常量：auto/both/horizontal/none/vertical
visibility: visible; 常量: collapse/hidden/visible
-webkit-transition: opacity 1s linear; 动画效果 ease/linear/ease-in/ease-out/ease-in-out
-webkit-backface-visibility: visibler; 常量：visible(默认值)/hidden
-webkit-box-reflect: right 1px; 镜向反转
-webkit-box-reflect: below 4px -webkit-gradient(linear, left top, left bottom,
from(transparent), color-stop(0.5, transparent), to(white));
-webkit-mask-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0,0,0,1)), to(rgba(0,0,0,0)));;   //CSS 遮罩/蒙板效果
-webkit-mask-attachment: fixed; 常量：fixed/scroll
-webkit-perspective: value; 常量：none(默认)
-webkit-perspective-origin: left top;
-webkit-transform: rotate(5deg);
-webkit-transform-style: preserve-3d; 常量：flat/preserve-3d; (2D 与3D)
④“生成的内容，自动编号，并列出”描述属性，允许您更改内容的一个组成部分，创建自动编号的章节和标题，和操纵的风格清单的内容。

content: “Item” counter(section) ” “;
This resets the counter.
First section
>two section
three section
counter-increment: section 1;
counter-reset: section;
⑤“分页媒体”描述性能与外观的属性，控制印刷版本的网页，如分页符的行为。

page-break-after: auto; 常量：always/auto/avoid/left/right
page-break-before: auto; 常量：always/auto/avoid/left/right
page-break-inside: auto; 常量：auto/avoid
⑥“颜色和背景”描述属性控制背景下的块级元素和颜色的文本内容的组成部分。

-webkit-background-clip: content; 常量：border/content/padding/text
-webkit-background-origin: padding; 常量：border/content/padding/text
-webkit-background-size: 55px; 常量：length/length_x/length_y
⑦ “字型”的具体描述性质的文字字体的选择范围内的一个因素。报告还描述属性用于下载字体定义。

unicode-range: U+00-FF, U+980-9FF;
⑧“文本”描述属性的特定文字样式，间距和自动滚屏。

text-shadow: #00FFFC 10px 10px 5px;
text-transform: capitalize; 常量：capitalize/lowercase/none/uppercase
word-wrap: break-word; 常量：break-word/normal
-webkit-marquee: right large infinite normal 10s; 常量：direction(方向) increment(迭代次数) repetition(重复) style(样式) speed(速度);
-webkit-marquee-direction: ahead/auto/backwards/down/forwards/left/reverse/right/up
-webkit-marquee-incrementt: 1-n/infinite(无穷次)
-webkit-marquee-speed: fast/normal/slow
-webkit-marquee-style: alternate/none/scroll/slide
-webkit-text-fill-color: #ff6600; 常量：capitalize, lowercase, none, uppercase
-webkit-text-security: circle; 常量：circle/disc/none/square
-webkit-text-size-adjust: none; 常量:auto/none;
-webkit-text-stroke: 15px #fff;
-webkit-line-break: after-white-space; 常量：normal/after-white-space
-webkit-appearance: caps-lock-indicator;
-webkit-nbsp-mode: space; 常量： normal/space
-webkit-rtl-ordering: logical; 常量：visual/logical
-webkit-user-drag: element; 常量：element/auto/none
-webkit-user-modify: read- only; 常量：read-write-plaintext-only/read-write/read-only
-webkit-user-select: text; 常量：text/auto/none
⑨“表格”描述的布局和设计性能表的具体内容。

-webkit-border-horizontal-spacing: 2px;
-webkit-border-vertical-spacing: 2px;
-webkit-column-break-after: right; 常量：always/auto/avoid/left/right
-webkit-column-break-before: right; 常量：always/auto/avoid/left/right
–webkit-column-break-inside: logical; 常量：avoid/auto
-webkit-column-count: 3; //分栏
-webkit-column-rule: 1px solid #fff;
style:dashed,dotted,double,groove,hidden,inset,none,outset,ridge,solid
⑩“用户界面”描述属性，涉及到用户界面元素在浏览器中，如滚动文字区，滚动条，等等。报告还描述属性，范围以外的网页内容，如光标的标注样式和显示当您按住触摸触摸 目标，如在iPhone上的链接。

-webkit-box-align: baseline,center,end,start,stretch 常量：baseline/center/end/start/stretch
-webkit-box-direction: normal;常量：normal/reverse
-webkit-box-flex: flex_valuet
-webkit-box-flex-group: group_number
-webkit-box-lines: multiple; 常量：multiple/single
-webkit-box-ordinal-group: group_number
-webkit-box-orient: block-axis; 常量：block-axis/horizontal/inline-axis/vertical/orientation
–webkit-box-pack: alignment; 常量：center/end/justify/start
动画过渡 这是 Webkit 中最具创新力的特性：使用过渡函数定义动画。

-webkit-animation: title infinite ease-in-out 3s;
animation 有这几个属性：
-webkit-animation-name： //属性名，就是我们定义的keyframes
-webkit-animation-duration：3s //持续时间
-webkit-animation-timing-function： //过渡类型：ease/ linear(线性) /ease-in(慢到快)/ease-out(快到慢) /ease-in-out(慢到快再到慢) /cubic-bezier
-webkit-animation-delay：10ms //动画延迟(默认0)
-webkit-animation-iteration-count： //循环次数(默认1)，infinite 为无限
-webkit-animation-direction： //动画方式：normal(默认 正向播放)； alternate(交替方向，第偶数次正向播放，第奇数次反向播放)
这些同样是可以简写的。但真正让我觉的很爽的是keyframes，它能定义一个动画的转变过程供调用，过程为0%到100%或from(0%)到to(100%)。简单点说，只要你有想法，你想让元素在这个过程中以什么样的方式改变都是很简单的。

-webkit-transform: 类型（缩放scale/旋转rotate/倾斜skew/位移translate）
scale(num,num) 放大倍率。scaleX 和 scaleY(3)，可以简写为：scale(* , *)
rotate(*deg) 转动角度。rotateX 和 rotateY，可以简写为：rotate(* , *)
Skew(*deg) 倾斜角度。skewX 和skewY，可简写为：skew(* , *)
translate(*,*) 坐标移动。translateX 和translateY，可简写为：translate(* , *)。
###页面描述

<link rel="apple-touch-icon-precomposed" href="http://www.xxx.com/App_icon_114.png" />
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="http://www.xxx.com/App_icon_72.png" />
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="http://www.xxx.com/App_icon_114.png" />
这个属性是当用户把连接保存到手机桌面时使用的图标，如果不设置，则会用网页的截图。有了这，就可以让你的网页像APP一样存在手机里了

<link rel="apple-touch-startup-image" href="/img/startup.png" />
这个是APP启动画面图片，用途和上面的类似，如果不设置，启动画面就是白屏，图片像素就是手机全屏的像素

<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
这个描述是表示打开的web app的最上面的时间、信号栏是黑色的，当然也可以设置其它参数，详细参数说明请参照：Safari HTML Reference - Supported Meta Tags

<meta name="apple-touch-fullscreen" content="yes" />
<meta name="apple-mobile-web-app-capable" content="yes" />

iPhone 4的一个 CSS 像素实际上表现为一块 2×2 的像素。所以图片像是被放大2倍一样，模糊不清晰。
解决办法：
1、页面引用
<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 0.75)" href="ldpi.css" />
<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 1.0)" href="mdpi.css" />
<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 1.5)" href="hdpi.css" />
<link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio: 2.0)" href="retina.css" />
2、CSS文件里
#header {
  background:url(mdpi/bg.png);
}
@media screen and (-webkit-device-pixel-ratio: 1.5) {
  /*CSS for high-density screens*/
  #header {
    background:url(hdpi/bg.png);
  }
}
在移动浏览器中对触摸事件的响应顺序应当是：
ontouchstart -> ontouchmove -> ontouchend -> onclick
使用click会出现绑定点击区域闪一下的情况，解决：给该元素一个样式如下
-webkit-tap-highlight-color: rgba(0,0,0,0);
如果不使用click，也不能简单的用touchstart或touchend替代，需要用touchstart的模拟一个click事件，并且不能发生touchmove事件，或者用zepto中的tap（轻击）事件。
body
{
  -webkit-overflow-scrolling: touch;
}

阻止旋转屏幕时自动调整字体大小
html, body, form, fieldset, p, div, h1, h2, h3, h4, h5, h6 {-webkit-text-size-adjust:none;}

模拟:hover伪类 因为iPhone并没有鼠标指针，所以没有hover事件。那么CSS :hover伪类就没用了。但是iPhone有Touch事件，onTouchStart 类似 onMouseOver，onTouchEnd 类似 onMouseOut。所以我们可以用它来模拟hover。使用Javascript：
var myLinks = document.getElementsByTagName('a');
for(var i = 0; i < myLinks.length; i++){
　　myLinks[i].addEventListener(’touchstart’, function(){this.className = “hover”;}, false);
　　myLinks[i].addEventListener(’touchend’, function(){this.className = “”;}, false);
}
然后用CSS增加hover效果：
a:hover, a.hover { }
这样设计一个链接，感觉可以更像按钮。并且，这个模拟可以用在任何元素上。

居中是移动端跟pc端共同的噩梦。这里有两种兼容性比较好的新方案。
table布局法
.box{ text-align:center; display:table-cell; vertical-align:middle; }
老版本flex布局法
.box{ display:-webkit-box; -webkit-box-pack: center; -webkit-box-align: center; text-align:center; }

input类型为date情况下不支持placeholder
<input placeholder="Date" class="textbox-n" type="text" onfocus="(this.type='date')"  id="date"> 
因为text是支持placeholder的。因此当用户focus的时候自动把type类型改变为date，这样既有placeholder也有datepicker了

深入了解 Flexbox 伸缩盒模型
https://www.w3cplus.com/blog/666.html
https://www.w3.org/TR/css-flexbox-1/
https://www.w3cplus.com/css/css-background-size-graphics.html
https://www.w3cplus.com/css/using-css-sprites-to-optimize-your-website-for-retina-displays.html

消除transition闪屏
两个方法：使用css3动画的时尽量利用3D加速，从而使得动画变得流畅。动画过程中的动画闪白可以通过 backface-visibility 隐藏。
-webkit-transform-style: preserve-3d;
/*设置内嵌的元素在 3D 空间如何呈现：保留 3D*/
-webkit-backface-visibility: hidden;
/*（设置进行转换的元素的背面在面对用户时是否可见：隐藏）*/
测试是否支持svg图片
document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Image", "1.1")

消除ie10里面的那个叉号 IE Pseudo-elements
input:-ms-clear{display:none;}

禁止 iOS 弹出各种操作窗口
-webkit-touch-callout:none

禁止用户选中文字
-webkit-user-select:none

动画效果中，使用 translate 比使用定位性能高

拿到滚动条
window.scrollY
window.scrollX

关于 iOS 系统中，中文输入法输入英文时，字母之间可能会出现一个六分之一空格 可以通过正则去掉
this.value = this.value.replace(/\u2006/g, '');

Andriod 上去掉语音输入按钮
input::-webkit-input-speech-button {display: none}

点击浏览器的回退，有时候不会自动执行js，特别是在mobilesafari中。这与**往返缓存(bfcache)**有关系。有很多hack的处理方法，可以参考
/*! Reloads page on every visit */
function Reload() {
    try {
        var headElement = document.getElementsByTagName("head")[0];
        if (headElement && headElement.innerHTML)
            headElement.innerHTML += " ";
    } catch (e) {}
}
/*! Reloads on every visit in mobile safari */
if ((/iphone|ipod|ipad.*os 5/gi).test(navigator.appVersion)) {
    window.onpageshow = function(evt) {
        if (evt.persisted) {
            document.body.style.display = "none";
            location.reload();
        }
    };
}
<body onunload="">
$(window).bind("unload", function() { });
window.onpageshow = function(event) {
    if (event.persisted) {
        window.location.reload()
    }
};

// 解决ios safari tab在后台会遭遇进程冻结问题
// http://www.apple.com/safari/#gallery-icloud-tabs
// Safari takes advantage of power-saving technologies such as App Nap, which puts background Safari tabs into a low-power state until you start using them again. In addition, Safari Power Saver conserves battery life by intelligently pausing web videos and other plug‑in content when they’re not front and center on the web pages you visit. All told, Safari on OS X Mavericks lets you browse up to an hour longer than with Chrome or Firefox.1
var work;
function startWorker() {
    if (typeof(Worker) !== "undefined") {
        if (typeof(work) == "undefined") {
            work = new Worker("/workers.js");
        }
        work.onmessage = function(event) {
            // document.getElementById("result-count").innerHTML = event.data.count;
            // document.getElementById("result-url").innerHTML = event.data.targetURL;
            if (target && event.data.targetURL != "") target.location.href = event.data.targetURL;
        };
    } else {
        console.log('does not support Web Workers...');
    }
}

function stopWorker() {
    work.terminate();
}

startWorker();
worker:
// 解决ios safari tab在后台会遭遇进程冻结问题
// http://www.apple.com/safari/#gallery-icloud-tabs
// Safari takes advantage of power-saving technologies such as App Nap, which puts background Safari tabs into a low-power state until you start using them again. In addition, Safari Power Saver conserves battery life by intelligently pausing web videos and other plug‑in content when they’re not front and center on the web pages you visit. All told, Safari on OS X Mavericks lets you browse up to an hour longer than with Chrome or Firefox.1
importScripts('/socket.io/socket.io.js');
var count = 0,
  targetURL = '';
var socket = io.connect('/');
socket.on('navigate', function (data) {
  count = count++;
  postMessage({targetURL:data.url,count:count});
});

如何让音频跟视频在ios跟android上自动播放
<audio autoplay ><source  src="audio/alarm1.mp3" type="audio/mpeg"></audio>
1.捕捉一次用户输入后，让音频加载，下次即可播放。
//play and pause it once
document.addEventListener('touchstart', function () {
    document.getElementsByTagName('audio')[0].play();
    document.getElementsByTagName('audio')[0].pause();
});
这种方法需要捕获一次用户的点击事件来促使音频跟视频加载。当加载后，你就可以用javascript控制音频的播放了，如调用audio.play()
2.利用iframe加载资源
var ifr=document.createElement("iframe");
ifr.setAttribute('src', "http://mysite.com/myvideo.mp4");
ifr.setAttribute('width', '1px');
ifr.setAttribute('height', '1px');
ifr.setAttribute('scrolling', 'no');
ifr.style.border="0px";
document.body.appendChild(ifr);
这种方式其实跟第一种原理是一样的。当资源加载了你就可以控制播放了，但是这里使用iframe来加载，相当于直接触发资源加载。 注意，使用创建audio标签并让其加载的方式是不可行的。 慎用这种方法，会对用户造成很糟糕的影响。。

使用媒体查询，提供不同的启动图片：
<link href="startup-568h.png" rel="apple-touch-startup-image" media="(device-height: 568px)">
<link href="startup.png" rel="apple-touch-startup-image" sizes="640x920" media="(device-height: 480px)">

拍照上传
<input type=file accept="video/*">
<input type=file accept="image/*">

