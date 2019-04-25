# DynamicDevelopment

## 简介
随着项目的变大，编译变得越来越慢，特别是对全局的宏作出修改后，编译的时间我已经可以发一条朋友圈了。该项目的目的是，利用Objective-C的动态特性，达到一种“所编即所得”的效果。

![](https://github.com/itenyh/DynamicDevelopment/blob/master/example.gif)

JSPatch的初衷是对线上产品进行热修复，该项目核心部分使用了JSPatch的特性。因为对JSPatch的修改和拓展较多，这里命名为JSPatchPlus。

## 安装

- 安装Xcode插件
1. 编译Bonjour项目，将生产的Product拖到Application，并启动一次
2. 重新启动Xcode
2. 打开你的项目，在菜单Editor中看到CodeTransport说明安装成功

- 安装DynamicDevelopment Engine
1. 将HotLoad文件直接拖进你的项目
2. 启动你的项目，出现灰色指示标志，首次执行CodeTransport指示标志变绿，说明引擎启动成功
3. 再次执行CodeTransport可发送当前页面的源代码至引擎进行“热编译”

## 其他

- 支持Masonry
- 通过Demo可体验热编译大部分能力
- 为了不至于每次都会尝试热编译整个文件，可使用\#pragma )(  排除一个方法；使用\#pragma () 仅仅编译这个方法。
