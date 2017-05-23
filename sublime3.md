sublime3
==========

###下载地址：http://www.sublimetext.com/3

###安装install package ctrl+` 输入以下代码：
```
import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())
```

###ctrl+shift+p输入install package回车后可搜索并安装如下插件：
* PHPIntel
* PhpDoc
* jquery
* AngularJS
* nodejs https://github.com/tanepiper/SublimeText-Nodejs
* ionic
* tag
* ctags
```sh
mac: brew install ctags
{
"command": "/usr/local/bin/ctags"
}
```
* windows: http://prdownloads.sourceforge.net/ctags/ctags58.zip
* BracketHighlighter 代码匹配
* Alignment (Ctrl+Alt+A等号对齐)
* SideBarEnhancements 侧栏右键功能增强
* AutoPrefixer CSS添加私有前缀
* JSFormat
* bootstrap3
* CodeIntel 代码自动提示
* git
```json
{
"git_command": "/usr/bin/git"
}
```
* GitGutter & Modific
* SublimeGit
* SVN
```json
{
	"email": "xiaosong@xiaosong.me",
	"sftp": "d419f6-de89e9-0aae59-2acea1-07f92a",
	"product_key": "99e640-c9cf0b-4a2764-f641fa-984434"
}
```
* sublimelinter 错误语法
* TrailingSpaces
* theme - spacegray
* Theme - Soda
* Terminal (ctrl+shit+t 打开命令行)
* ConvertToUTF8/Codecs33 https://github.com/seanliang/Codecs33/tree/osx
* AutoFileName
* SublimeTmpl 快速生成文件模板
* SublimeTmpl默认的快捷键
ctrl+alt+h html
ctrl+alt+j javascript
ctrl+alt+c css
ctrl+alt+p php
ctrl+alt+r ruby
ctrl+alt+shift+p python
* DocBlockr
* javascript completions
* ColorPicker 调色盘
* Emmet
* HTML5
* Minifier (ctrl + alt + m)(ctrl + alt + shift + m)
* Pretty JSON (ctrl+alt+j 格式化json字符串 ctrl+alt+m 压缩json字符串)
* Markdown PreView
setting: {"enable_highlight": true}
key bindings user: { "keys": ["alt+m"], "command": "markdown_preview", "args": { "target": "browser"} }
* SublimeREPL
* FileDiffs
* setting-user 配置
```json
{
    "color_scheme": "Packages/Theme - Spacegray/base16-ocean.dark.tmTheme",
    "font_size": 14.0,
    "tab_size": 4,
    "theme": "Spacegray.sublime-theme",
    "translate_tabs_to_spaces": false,
	"word_wrap": true,
	"wrap_width": 100
}
```
* lua
tool->build system->new build system
{
    "cmd": ["lua", "$file"],
    "file_regex": "^(?:lua:)?[\t ](...*?):([0-9]*):?([0-9]*)",
    "selector": "source.lua"
}
lua.sublime-build
ctrl + b 运行
* Java​Script & Node​JS Snippets
* AdvancedNewFile
* TypeScript/Babel/React
###key
```
—– BEGIN LICENSE —–
K-20
Single User License
EA7E-940129
3A099EC1 C0B5C7C5 33EBF0CF BE82FE3B
EAC2164A 4F8EC954 4E87F1E5 7E4E85D6
C5605DE6 DAB003B4 D60CA4D0 77CB1533
3C47F579 FB3E8476 EB3AA9A7 68C43CD9
8C60B563 80FE367D 8CAD14B3 54FB7A9F
4123FFC4 D63312BA 141AF702 F6BBA254
B094B9C0 FAA4B04C 06CC9AFC FD412671
82E3AEE0 0F0FAAA7 8FA773C9 383A9E18
—— END LICENSE ——

—– BEGIN LICENSE —–
Ryan Clark
Single User License
EA7E-812479
2158A7DE B690A7A3 8EC04710 006A5EEB
34E77CA3 9C82C81F 0DB6371B 79704E6F
93F36655 B031503A 03257CCC 01B20F60
D304FA8D B1B4F0AF 8A76C7BA 0FA94D55
56D46BCE 5237A341 CD837F30 4D60772D
349B1179 A996F826 90CDB73C 24D41245
FD032C30 AD5E7241 4EAA66ED 167D91FB
55896B16 EA125C81 F550AF6B A6820916
—— END LICENSE ——
```

###常用快捷键
```
查找
快速查找（Ctrl + P）
输入@+函数名可以快速找到函数。
输入#+文本可以快速进行文件内文本匹配。
Ctrl + F 查找
Ctrl + Alt + F 当前文件查找替换
Ctrl + Shift + F 多文件查找替换
跳转
Ctrl + G 跳到指定行号
Ctrl + M 括号对称跳转
Ctrl + R 跳转到指定方法
选择
Ctrl + D 选择单词
Ctrl + L 选择行
删除
Ctrl + X 删除当前行
Ctrl + Shift + K 删除当前行
Ctrl + K K 删除到行末尾
新开一行
Ctrl + Enter 在当前行的后面新开一行
Ctrl + Shift + Enter 在当前行的前面新开一行
注释
Ctrl + / 注释或者去注释
功能
1. 可以直接打开图片
版本3有个很好的特性（对于前端来说）：可以直接在ST3中打开图片。
2. Goto Anything功能 — 快速查找（ctrl + P）
输入@+函数名可以快速找到函数。
输入#+文本可以快速进行文件内文本匹配。
3. 多行游标功能（ctrl + D，非常实用）
如何将文件中的某个单词更改为另一个？
方法一：利用查找替换功能：ctrl + H
方法二（推荐）：多行游标功能，选中一个后，按ctrl+D可以同时选中另一个，同时多了另一个光标。
但多行游标能完成查找替换功能不能完成的工作。
比如在某些符合条件的语句后面添加新行，同时加入一些新的文本，如何快速的达到这一目的？
可以选中某一个模式，然后ctrl+D选中另一个，如果有某些不想添加新行的模式则按ctrl+K，ctrl+D跳过这个进入下一个符合条件的模式行。
还可以按Alt + F3快捷键全选所有符合条件的单词，产生多个光标，而不用一个个ctrl+D选中。
如果要在每行都加入光标，可以先ctrl+A然后ctrl+shift+L即可。
如果想在某个字符的多行后面加上光标，可以将光标放在这个字符后面，按住shift键，然后右键可以向下拖动产生多个光标。
4. 命令模式（应尽可能使用，而不用浪费脑细胞记忆大量命令的快捷键）
比如用ctrl+N新建一个文件后，默认是plain text，没有语法高亮功能，如何设置语法模式？
可以通过右下角的语法选择区选择希望设置的语法模式。
还有另一种更好的办法，即使用ctrl + shift + P打开命令模式，然后输入set syntax [language]设置为某种语言的语法模式，比如set syntax java则设置为java语法高亮。
st3支持模糊匹配，你也可以直接输入syntax java或ssjava。
若当前已经是某种语言的语法模式，则可以直接输入其它语言进行切换（而不用输入set syntax或syntax了），比如当然为java语法模式，那么直接输入js就可以马上切换为javascript语法模式。
还可以输入minimap隐藏或显示右边的minimap缩影
5. 快速跳转到某一行
按下Ctrl + G，输入行号，可以快速跳转到该行。
6. 快速添加新行
Ctrl + Enter可以在当前行下新建一行。
Ctrl + Shift + Enter可以在当前行上面添加一行。
7. 多行缩进
选中多行后按Ctrl + ]可以增加缩进，按Ctrl + [可以减少缩进。
PS：发现用Tab和Shift + Tab也是可以的。
8. 完整拷贝，避免格式错乱
我们发现，在从别的文件中拷贝一段代码过来的时候，多半只是第一行缩进，后面都乱了，这时可以使用Ctrl + Shift + V进行粘贴，可以在粘贴的过程中保持缩进，这时格式都是正确的。
9. 重新打开关闭的标签
在Chrome里面，如果你不小心关闭了某个标签页并想恢复它，你可以按下Shift + Ctrl + T重新打开它。
在ST3中也一样，如果你不小心关闭了某个文件，可以按下Shift + Ctrl + T快速恢复。连续重复该按键，ST将会按照关闭的先后顺序重新打开标签页。
10. 按住shift + ctrl然后按←或→可快速选中一行中的某一部分，连续按扩大选择范围。
比如你需要将某一部分进行注释(ctrl+/)或删除，使用这个功能就很方便。
11. 上下移动行
定位光标或选中某块区域，然后按shift+ctrl+↑↓可以上下移动该行。
12. shift + ctrl + d可快速复制光标所在的一整行，并复制到该行之前。
13. Ctrl+Shift+M：选中花括号里面的全部内容不包括{}。
14. Ctrl+Shift+K：删除整行。
15. 快速关闭HTML里的标签
```



