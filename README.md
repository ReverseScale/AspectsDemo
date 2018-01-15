# AspectsDemo
基于 Aspects 简单展示 AOP（面向切面）编程 🤖

> 统计打点是 App 开发里很重要的一个环节，App 的运行状态、改版后的效果、用户的各种行为等都需要打点，所以需要一种更好的方式来做这件事，这就是使用 AOP(Aspect-Oriented-Programming)，翻译过来就是「面向切面编程」

![](http://og1yl0w9z.bkt.clouddn.com/18-1-15/34837673.jpg)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-4.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

----
### 🤖 要求

* iOS 8.0+
* Xcode 7.0+

----
### 🎨 测试 UI 什么样子？

| 名称 |1.展示页 |2.展示页 |3.展示页 |
| ------------- | ------------- | ------------- | ------------- | 
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/18-1-15/840928.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-1-15/49794754.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-1-15/6455284.jpg) | 
| 描述 | 展示列表 | 拦截系统事件 | 自定义拦截 | 

----
### 🎯 安装方法

#### 安装

在 *iOS*, 你需要在 Podfile 中添加.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod "Aspects"
```

----
### 🛠 配置

#### 系统级拦截

拦截系统级级事件，如 viewWillAppear 等

```Objective-C
#import <Aspects.h>
#import <objc/runtime.h>

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"View Controller %@ will appear animated: %tu", aspectInfo.instance, animated);
    } error:NULL];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"System View Controller will appear");
}
```

#### 自定义拦截

拦截自定义事件，如对类的操作

```Objective-C
// Cat.h 类
@interface Cat: NSObject
+ (void)classFee;
@end

// Cat.m 类
@implementation Cat
+ (void)classFee {
    NSLog(@"Miao~");
}
@end

// 实现方法
#import "Cat.h"
#import <Aspects.h>
#import <objc/runtime.h>

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Class catMetal = objc_getMetaClass(NSStringFromClass(Cat.class).UTF8String);
    
    [catMetal aspect_hookSelector:@selector(classFee) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"Miao~,I am angry~");
    } error:NULL];
    
    [Cat classFee];
}

```

----
### 📝 深入学习

Aspects: https://github.com/steipete/Aspects


----
### ⚖ 协议

```
MIT License

Copyright (c) 2017 ReverseScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

----
### 😬 联系

* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io
