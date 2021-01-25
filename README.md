# AspectsDemo

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-4.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

> AOP(Aspect-Oriented-Programming)，翻译过来就是「面向切面编程」，使用场景如统计打点这种需求等

<img width="300" height="300" src="https://user-gold-cdn.xitu.io/2018/3/8/1620383676cb248d?w=650&h=650&f=jpeg&s=28654"/><img width="300" height="300" src="https://user-gold-cdn.xitu.io/2018/3/8/1620383676cb248d?w=650&h=650&f=jpeg&s=28654"/>

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

---
### 🎨 测试 UI 什么样子？

|1.展示页 |2.展示页 |3.展示页 |
| ------------- | ------------- | ------------- | 
| ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c3818513f78?w=358&h=704&f=png&s=30744) | ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c3817e1a775?w=358&h=704&f=png&s=28277) | ![](https://user-gold-cdn.xitu.io/2018/3/15/16227c38138b1caa?w=358&h=704&f=png&s=35355) | 
| 展示列表 | 拦截系统事件 | 自定义拦截 | 

----
### 📝 深入学习
索引：
* AOP 简介
* Aspects 简介
* Aspects 结构剖析
* Aspects 核心代码剖析
* 优秀 AOP 库应该具备的特质
* 总结

#### AOP 简介

在 Objective-C 的实现结构中 Runtime 的动态派发机制保证了这么语言的灵活性，而在运行时，动态地将代码切入到类的指定方法、指定位置上的编程思想就是AOP(面向切面编程)。

> AOP 是一种编程范式或者编程思想，它解决了 OOP (Object-oriented programming) 的延伸问题

##### 什么时候需要使用 AOP

假设随着我们所在的公司逐步发展，之前第三方的用户页面统计已经不能满足需求了，公司要求实现一个我们自己的用户页面统计。

在传统的 OOP 思想下，可能会如下操作：

* 一个熟悉 OOP 思想的程序猿会理所应当的想到要把用户页面统计这一任务放到 ViewController 中；
* 考虑到一个个的手动添加统计代码要死人（而且还会漏，以后新增 ViewController 也要手动加），于是想到了 OOP 思想中的继承；
* 不巧由于项目久远，所有的 ViewController 都是直接继承自系统类 UIViewController（笑），此时选择抽一个项目 RootViewController，替换所有 ViewController 继承 RootViewController；
* 然后在 RootViewController 的 viewWillAppear: 和 viewWillDisappear: 方法加入时间统计代码，记录 ViewController 以及 Router 传参。

其实 OOP 也有其特殊的定位，也能够实现上述的需求。

而 AOP 则更适合在给多个 App 写通用组件并以通用的形式实现统计的情况下。

一个简单的思路：Hook 方法交换的方法，在原方法执行之后记录需要统计的信息并上报。

> 单通过 Method Swizzling 来 Hook 的方法在处理不当的情况下容易出现安全隐患

#### Aspects 简介

![](https://user-gold-cdn.xitu.io/2018/6/8/163dd675f76572e2?w=750&h=428&f=jpeg&s=66163)

Aspects 是一个使用起来简单愉快的 AOP 库，使用 Objective-C 编写，适用于 iOS 与 Mac OS X。

Aspects 简单易用，作者通过在 NSObject (Aspects) 分类中暴露出的两个接口分别提供了对实例和 Class 的 Hook 实现：

```objc
@interface NSObject (Aspects)
+ (id)aspect_hookSelector:(SEL)selector
                      withOptions:(AspectOptions)options
                       usingBlock:(id)block
                            error:(NSError **)error;
- (id)aspect_hookSelector:(SEL)selector
                      withOptions:(AspectOptions)options
                       usingBlock:(id)block
                            error:(NSError **)error;
@end
```

Aspects 支持实例 Hook，相较其他 Objective-C AOP 库而言可操作粒度更小，适合的场景更加多样化。作为使用者无需进行更多的操作即可 Hook 指定实例或者 Class 的指定 SEL，AspectOptions 参数可以指定 Hook 的点，以及是否执行一次之后就撤销 Hook。

#### Aspects 结构剖析

![](https://user-gold-cdn.xitu.io/2018/6/8/163dd69fa172ac02?w=750&h=357&f=png&s=43594)

尽管 Aspects 只有不到千行的源码，但是其内部实现考虑到了很多 Hook 相关的安全问题和其他细节，对比其他 Objective-C AOP 开源项目来说 Aspects 更为健全。

##### Aspects 内部结构

Aspects 内部定义了两个协议：

* AspectToken - 用于注销 Hook
* AspectInfo - 嵌入 Hook 中的 Block 首位参数

此外 Aspects 内部还定义了 4 个类：

* AspectInfo - 切面信息，遵循 AspectInfo 协议
* AspectIdentifier - 切面 ID，应该遵循 AspectToken 协议（作者漏掉了，已提 PR）
* AspectsContainer - 切面容器
* AspectTracker - 切面跟踪器

以及一个结构体：

* AspectBlockRef - 即 _AspectBlock，充当内部 Block
如果你扒一遍源码，还会发现两个内部静态全局变量：

* static NSMutableDictionary *swizzledClassesDict;
* static NSMutableSet *swizzledClasses;

##### Aspects 协议

*AspectToken*

AspectToken 协议旨在让使用者可以灵活的注销之前添加过的 Hook，内部规定遵守此协议的对象须实现 remove 方法。

```objc
/// 不透明的 Aspect Token，用于注销 Hook
@protocol AspectToken /// 注销一个 aspect.
/// 返回 YES 表示注销成功，否则返回 NO
- (BOOL)remove;
@end
```

*AspectInfo*

AspectInfo 协议旨在规范对一个切面，即 aspect 的 Hook 内部信息的纰漏，我们在 Hook 时添加切面的 Block 第一个参数就遵守此协议。

```objc
/// AspectInfo 协议是我们块语法的第一个参数。
@protocol AspectInfo /// 当前被 Hook 的实例
- (id)instance;
/// 被 Hook 方法的原始 invocation
- (NSInvocation *)originalInvocation;
/// 所有方法参数（装箱之后的）惰性执行
- (NSArray *)arguments;
@end
```

> 装箱是一个开销昂贵操作，所以用到再去执行

##### Aspects 内部类

接着协议，我们下面详细介绍一下 Aspects 的内部类。

*AspectInfo*

AspectInfo 在这里是一个 Class，其遵守上文中讲到的 AspectInfo 协议，不要混淆。

```objc
@interface AspectInfo : NSObject 
- (id)initWithInstance:(__unsafe_unretained id)instance invocation:(NSInvocation *)invocation;
@property (nonatomic, unsafe_unretained, readonly) id instance;
@property (nonatomic, strong, readonly) NSArray *arguments;
@property (nonatomic, strong, readonly) NSInvocation *originalInvocation;
@end
```

AspectInfo 比较简单，参考 ReactiveCocoa 团队提供的 NSInvocation 参数通用方法可将参数装箱为 NSValue，简单来说 AspectInfo 扮演了一个提供 Hook 信息的角色。

*AspectIdentifier*

AspectIdentifier 类定义：

```objc
@interface AspectIdentifier : NSObject
+ (instancetype)identifierWithSelector:(SEL)selector object:(id)object options:(AspectOptions)options block:(id)block error:(NSError **)error;
- (BOOL)invokeWithInfo:(id)info;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id block;
@property (nonatomic, strong) NSMethodSignature *blockSignature;
@property (nonatomic, weak) id object;
@property (nonatomic, assign) AspectOptions options;
@end
```

AspectIdentifier 实际上是添加切面的 Block 的第一个参数，其应该遵循 AspectToken 协议，事实上也的确如此，其提供了 remove 方法的实现。

AspectIdentifier 内部需要注意的是由于使用 Block 来写 Hook 中我们加的料，这里生成了 blockSignature，在 AspectIdentifier 初始化的过程中会去判断 blockSignature 与入参 object 的 selector 得到的 methodSignature 的兼容性，兼容性判断成功才会顺利初始化。

*AspectsContainer*

AspectsContainer 作为切面的容器类，关联指定对象的指定方法，内部有三个切面队列，分别容纳关联指定对象的指定方法中相对应 AspectOption 的 Hook：

* NSArray *beforeAspects; - AspectPositionBefore
* NSArray *insteadAspects; - AspectPositionInstead
* NSArray *afterAspects; - AspectPositionAfter

AspectsContainer 在 NSObject 分类中通过 AssociatedObject 方法与当前要 Hook 的目标关联在一起的。

```objc
@interface AspectsContainer : NSObject
- (void)addAspect:(AspectIdentifier *)aspect withOptions:(AspectOptions)injectPosition;
- (BOOL)removeAspect:(id)aspect;
- (BOOL)hasAspects;
@property (atomic, copy) NSArray *beforeAspects;
@property (atomic, copy) NSArray *insteadAspects;
@property (atomic, copy) NSArray *afterAspects;
@end
```

> 关联目标是 Hook 之后的 Selector，即 aliasSelector（原始 SEL 名称加 aspects_ 前缀对应的 SEL）

*AspectTracker*

AspectTracker 类定义：

```objc
@interface AspectTracker : NSObject
- (id)initWithTrackedClass:(Class)trackedClass parent:(AspectTracker *)parent;
@property (nonatomic, strong) Class trackedClass;
@property (nonatomic, strong) NSMutableSet *selectorNames;
@property (nonatomic, weak) AspectTracker *parentEntry;
@end
```

AspectTracker 作为切面追踪器，原理大致如下：

```objc
// Add the selector as being modified.
currentClass = klass;
AspectTracker *parentTracker = nil;
do {
    AspectTracker *tracker = swizzledClassesDict[currentClass];
    if (!tracker) {
        tracker = [[AspectTracker alloc] initWithTrackedClass:currentClass parent:parentTracker];
        swizzledClassesDict[(id)currentClass] = tracker;
    }
    [tracker.selectorNames addObject:selectorName];
    // All superclasses get marked as having a subclass that is modified.
    parentTracker = tracker;
}while ((currentClass = class_getSuperclass(currentClass)));
```

全局变量 swizzledClassesDict 中的 value 对应着 AspectTracker 指针。

AspectTracker 是从下而上追踪，最底层的 parentEntry 为 nil，父类的 parentEntry 为子类的 tracker。

*Aspects 静态全局变量*

1）static NSMutableDictionary *swizzledClassesDict;

static NSMutableDictionary *swizzledClassesDict; 在 Aspects 中扮演着已混写类字典的角色，Aspects 内部提供了专门访问这个全局字典的方法：

```objc
static NSMutableDictionary *aspect_getSwizzledClassesDict() {
    static NSMutableDictionary *swizzledClassesDict;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        swizzledClassesDict = [NSMutableDictionary new];
    });
    return swizzledClassesDict;
}
```

这个全局变量可以简单理解为记录整个 Hook 影响的 Class 包含其 SuperClass 的追踪记录的全局字典。

2）static NSMutableSet *swizzledClasses;

static NSMutableSet *swizzledClasses; 在 Aspects 中担当记录已混写类的角色，Aspects 内部提供一个用于修改这个全局变量内容的方法：

```objc
static void _aspect_modifySwizzledClasses(void (^block)(NSMutableSet *swizzledClasses)) {
    static NSMutableSet *swizzledClasses;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        swizzledClasses = [NSMutableSet new];
    });
    @synchronized(swizzledClasses) {
        block(swizzledClasses);
    }
}
```

#### Aspects 核心代码剖析

##### Hook Class && Hook Instance

Aspects 不光支持 Hook Class 还支持 Hook Instance，这提供了更小粒度的控制，配合 Hook 的撤销功能可以更加灵活精准的实现功能。

```objc
static Class aspect_hookClass(NSObject *self, NSError **error) {
    // 断言 self
    NSCParameterAssert(self);
    // class
Class statedClass = self.class;
// isa
Class baseClass = object_getClass(self);
NSString *className = NSStringFromClass(baseClass);
    // 已经子类化过了
if ([className hasSuffix:AspectsSubclassSuffix]) {
return baseClass;
        // 我们混写了一个 class 对象，而非一个单独的 object
}else if (class_isMetaClass(baseClass)) {
    // baseClass 是元类，则 self 是 Class 或 MetaClass，混写 self
        return aspect_swizzleClassInPlace((Class)self);
        // 可能是一个 KVO'ed class。混写就位。也要混写 meta classes。
    }else if (statedClass != baseClass) { 
        // 当 .class 和 isa 指向不同的情况，混写 baseClass
        return aspect_swizzleClassInPlace(baseClass);
    }
    // 默认情况下，动态创建子类
    // 拼接子类后缀 AspectsSubclassSuffix
const char *subclassName = [className stringByAppendingString:AspectsSubclassSuffix].UTF8String;
// 尝试用拼接后缀的名称获取 isa
Class subclass = objc_getClass(subclassName);
    // 找不到 isa，代表还没有动态创建过这个子类
if (subclass == nil) {
    // 创建一个 class pair，baseClass 作为新类的 superClass，类名为 subclassName
subclass = objc_allocateClassPair(baseClass, subclassName, 0);
if (subclass == nil) { // 返回 nil，即创建失败
            NSString *errrorDesc = [NSString stringWithFormat:@"objc_allocateClassPair failed to allocate class %s.", subclassName];
            AspectError(AspectErrorFailedToAllocateClassPair, errrorDesc);
            return nil;
        }
        // 混写 forwardInvocation:
aspect_swizzleForwardInvocation(subclass);
// subClass.class = statedClass
aspect_hookedGetClass(subclass, statedClass);
// subClass.isa.class = statedClass
aspect_hookedGetClass(object_getClass(subclass), statedClass);
// 注册新类
objc_registerClassPair(subclass);
}
    // 覆盖 isa
object_setClass(self, subclass);
return subclass;
}
```

难点就在于对 .class 和 object_getClass 的区分。

* .class 当 target 是 Instance 则返回 Class，当 target 是 Class 则返回自身
* object_getClass 返回 isa 指针的指向

动态创建一个 Class 的完整步骤也是我们应该注意的。

* objc_allocateClassPair
* class_addMethod
* class_addIvar
* objc_registerClassPair 

##### Hook 的实现

在上面 aspect_hookClass 方法中，不仅仅是返回一个要 Hook 的 Class，期间还做了一些细节操作，不论是 Class 还是 Instance，都会调用 aspect_swizzleForwardInvocation 方法，这个方法没什么难点，简单贴一下代码让大家有个印象：

```objc
static void aspect_swizzleForwardInvocation(Class klass) {
    // 断言 klass
    NSCParameterAssert(klass);
    // 如果没有 method，replace 实际上会像是 class_addMethod 一样
    IMP originalImplementation = class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)__ASPECTS_ARE_BEING_CALLED__, "v@:@");
    // 拿到 originalImplementation 证明是 replace 而不是 add，情况少见
    if (originalImplementation) {
        // 添加 AspectsForwardInvocationSelectorName 的方法，IMP 为原生 forwardInvocation:
        class_addMethod(klass, NSSelectorFromString(AspectsForwardInvocationSelectorName), originalImplementation, "v@:@");
    }
    AspectLog(@"Aspects: %@ is now aspect aware.", NSStringFromClass(klass));
}
```

上面的方法就是把要 Hook 的目标 Class 的 forwardInvocation: 混写了，混写之后 forwardInvocation: 的具体实现在 __ASPECTS_ARE_BEING_CALLED__ 中，里面能看到 invoke 标识位的不同是如何实现的，还有一些其他的实现细节：

```objc
// 宏定义，以便于我们有一个更明晰的 stack trace
#define aspect_invoke(aspects, info) \
for (AspectIdentifier *aspect in aspects) {\
    [aspect invokeWithInfo:info];\
    if (aspect.options & AspectOptionAutomaticRemoval) { \
        aspectsToRemove = [aspectsToRemove?:@[] arrayByAddingObject:aspect]; \
    } \
}
static void __ASPECTS_ARE_BEING_CALLED__(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    // __unsafe_unretained NSObject *self 不解释了
    // 断言 self, invocation
    NSCParameterAssert(self);
    NSCParameterAssert(invocation);
    // 从 invocation 可以拿到很多东西，比如 originalSelector
    SEL originalSelector = invocation.selector;
    // originalSelector 加前缀得到 aliasSelector
SEL aliasSelector = aspect_aliasForSelector(invocation.selector);
// 用 aliasSelector 替换 invocation.selector
    invocation.selector = aliasSelector;
     
    // Instance 的容器
    AspectsContainer *objectContainer = objc_getAssociatedObject(self, aliasSelector);
    // Class 的容器
    AspectsContainer *classContainer = aspect_getContainerForClass(object_getClass(self), aliasSelector);
    AspectInfo *info = [[AspectInfo alloc] initWithInstance:self invocation:invocation];
    NSArray *aspectsToRemove = nil;
    // Before hooks.
    aspect_invoke(classContainer.beforeAspects, info);
    aspect_invoke(objectContainer.beforeAspects, info);
    // Instead hooks.
    BOOL respondsToAlias = YES;
    if (objectContainer.insteadAspects.count || classContainer.insteadAspects.count) {
        // 如果有任何 insteadAspects 就直接替换了
        aspect_invoke(classContainer.insteadAspects, info);
        aspect_invoke(objectContainer.insteadAspects, info);
    }else { // 否则正常执行
        // 遍历 invocation.target 及其 superClass 找到实例可以响应 aliasSelector 的点 invoke
        Class klass = object_getClass(invocation.target);
        do {
            if ((respondsToAlias = [klass instancesRespondToSelector:aliasSelector])) {
                [invocation invoke];
                break;
            }
        }while (!respondsToAlias && (klass = class_getSuperclass(klass)));
    }
    // After hooks.
    aspect_invoke(classContainer.afterAspects, info);
    aspect_invoke(objectContainer.afterAspects, info);
    // 如果没有 hook，则执行原始实现（通常会抛出异常）
    if (!respondsToAlias) {
        invocation.selector = originalSelector;
        SEL originalForwardInvocationSEL = NSSelectorFromString(AspectsForwardInvocationSelectorName);
        // 如果可以响应 originalForwardInvocationSEL，表示之前是 replace method 而非 add method
        if ([self respondsToSelector:originalForwardInvocationSEL]) {
            ((void( *)(id, SEL, NSInvocation *))objc_msgSend)(self, originalForwardInvocationSEL, invocation);
        }else {
            [self doesNotRecognizeSelector:invocation.selector];
        }
    }
    // 移除 aspectsToRemove 队列中的 AspectIdentifier，执行 remove
    [aspectsToRemove makeObjectsPerformSelector:@selector(remove)];
}
#undef aspect_invoke
```

> aspect_invoke 宏定义的作用域

* 代码实现对应了 Hook 的 AspectOptions 参数的 Before，Instead 和 After。
* aspect_invoke 中 aspectsToRemove 是一个 NSArray，里面容纳着需要被销户的 Hook，即 AspectIdentifier（之后会调用 remove 移除）。
* 遍历 invocation.target 及其 superClass 找到实例可以响应 aliasSelector 的点 invoke 实现代码。

*Block Hook*

Aspects 让我们在指定 Class 或 Instance 的特定 Selector 执行时，根据 AspectOptions 插入我们自己的 Block 做 Hook，而这个 Block 内部有我们想要的有关于当前 Target 和 Selector 的信息，我们来看一下 Aspects 是怎么办到的：

```objc
- (BOOL)invokeWithInfo:(id)info {
    NSInvocation *blockInvocation = [NSInvocation invocationWithMethodSignature:self.blockSignature];
    NSInvocation *originalInvocation = info.originalInvocation;
    NSUInteger numberOfArguments = self.blockSignature.numberOfArguments;
    // 偏执。我们已经在 hook 注册的时候检查过了，（不过这里我们还要检查）。
    if (numberOfArguments > originalInvocation.methodSignature.numberOfArguments) {
        AspectLogError(@"Block has too many arguments. Not calling %@", info);
        return NO;
    }
    // block 的 `self` 将会是 AspectInfo。可选的。
    if (numberOfArguments > 1) {
        [blockInvocation setArgument:&info atIndex:1];
    }
     
    // 简历参数分配内存 argBuf 然后从 originalInvocation 取 argument 赋值给 blockInvocation
void *argBuf = NULL;
    for (NSUInteger idx = 2; idx < numberOfArguments; idx++) {
        const char *type = [originalInvocation.methodSignature getArgumentTypeAtIndex:idx];
NSUInteger argSize;
NSGetSizeAndAlignment(type, &argSize, NULL);
         
        // reallocf 优点，如果创建内存失败会自动释放之前的内存，讲究
if (!(argBuf = reallocf(argBuf, argSize))) {
            AspectLogError(@"Failed to allocate memory for block invocation.");
return NO;
}
         
[originalInvocation getArgument:argBuf atIndex:idx];
[blockInvocation setArgument:argBuf atIndex:idx];
    }
    // 执行
    [blockInvocation invokeWithTarget:self.block];
    // 释放 argBuf
    if (argBuf != NULL) {
        free(argBuf);
    }
    return YES;
}
```

考虑两个问题：

* [blockInvocation setArgument:&info atIndex:1]; 为什么要在索引 1 处插入呢？
* for (NSUInteger idx = 2; idx < numberOfArguments; idx++) 为什么要从索引 2 开始遍历参数呢？

#### 优秀 AOP 库应该具备的特质

* 良好的使用体验
* 可控粒度小
* 使用 Block 做 Hook
* 支持撤销 Hook
* 安全性

##### 良好的使用体验

Aspects 使用 NSObject + Categroy 的方式提供接口，非常巧妙的涵盖了 Instance 和 Class。

Aspects 提供的接口保持高度一致（本着易用，简单，方便的原则设计接口和整个框架的实现会让你的开源项目更容易被人们接纳和使用）：

```objc
+ (id)aspect_hookSelector:(SEL)selector
                      withOptions:(AspectOptions)options
                       usingBlock:(id)block
                            error:(NSError **)error;
- (id)aspect_hookSelector:(SEL)selector
                      withOptions:(AspectOptions)options
                       usingBlock:(id)block
                            error:(NSError **)error;
```

##### 可控粒度小

Aspects 不仅支持大部分 AOP 框架应该做到的对于 Class 的 Hook，还支持粒度更小的 Instance Hook，而其在内部实现中为了支持 Instance Hook 所做的代码也非常值得我们参考和学习（已在上文 Aspects 核心代码剖析处单独分析）。

为使用者提供更为自由的 Hook 方式以达到更加精准的控制是每个使用者乐于见到的事。

##### 使用 Block 做 Hook

Aspects 使用 Block 来做 Hook 应该考虑到了很多东西，支持使用者通过在 Block 中获取到相关的信息，书写自己额外的操作就可以实现 Hook 需求。

##### 支持撤销 Hook

Aspects 还支持撤销之前做的 Hook 以及已混写的 Method，为了实现这个功能 Aspects 设计了全局容器，把 Hook 和混写用全局容器做记录，让一切都可以复原，这不正是我们想要的吗？

##### 安全性

在学习 Runtime 的时候，就应该看到过不少文章讲解 Method Swizzling 要注意的安全性问题，由于用到了大量 Runtime 方法，加上 AOP 是面向整个切面的，所以一单发现问题就会比较严重，设计的面会比较广，而且难以调试。

> 不能因为容易造成问题就可以回避 Method Swizzling，就好比大学老师讲到递归时强调容易引起循环调用，很多人就在内心回避使用递归，甚至于非常适合使用递归来写的算法题（这里指递归来写会易读写、易维护）只会用复杂的方式来思考。

#### 总结

* 文章简单介绍了 AOP 的概念，希望能给各位读者对 AOP 思想的理解提供微薄的帮助。
* 文章系统的剖析了 Aspects 开源库的内部结构，希望能让大家在浏览 Aspects 源码时快速定位代码位置，找到核心内容。
* 文章重点分析了 Aspects 的核心代码，提炼了一些笔者认为值得注意的点，但愿可以在大家扒源码时提供一些指引。
* 文章结尾总结了 Aspects 作为一个比较优秀的 AOP 开源库所具有的特质，不过毕竟是很久之前的代码了，如果有哪位想要造一个关于 AOP 的轮子，希望这篇文章能够产生些许帮助。

---
### 😬 联系

* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io


> Aspects原理部分来源：https://lision.me/aspects/
