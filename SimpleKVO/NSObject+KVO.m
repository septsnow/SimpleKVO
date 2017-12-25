//
//  NSObject+KVO.m
//  SimpleKVO
//
//  Created by lucky on 2017/12/24.
//  Copyright © 2017年 lucky. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define kLsClassNamePrefix @"Ls_"
#define kKey @"djjj"


@interface ObserverInfo : NSObject
@property (nonatomic, copy) NSObject* observer;
@property (nonatomic, copy) NSString* key;
- (instancetype)initWithObserver:(NSObject *)observer key:(NSString *)key;

@end

@implementation ObserverInfo
- (instancetype)initWithObserver:(NSObject *)observer key:(NSString *)key {
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
    }
    return self;
}
@end


@implementation NSObject (KVO)
static void setMethod(id self, SEL _cmd, id newValue) {
    NSString* setterName = NSStringFromSelector(_cmd);
    NSString* getterName = [setterName substringFromIndex:4];
    getterName = [NSString stringWithFormat:@"%@%@", [setterName substringWithRange:NSMakeRange(3, 1)].lowercaseString, getterName];
    getterName = [getterName substringToIndex:getterName.length - 1];
    
    // setter方法的任务有两个
    // 1. 告诉所有的监听此属性的对象, 对象属性发生改变
    NSMutableArray* observers = objc_getAssociatedObject(self, kKey.UTF8String);
    for (ObserverInfo* info in observers) {
        if ([info.key isEqualToString:getterName]) {
            if ([info.observer respondsToSelector:@selector(observeNewValue:)]) {
                [info.observer performSelector:@selector(observeNewValue:) withObject:newValue];
            }
        }
    }
    
    // 2. 调用父类的setter方法
    struct objc_super superClass = {
        .receiver = self,
        .super_class = class_getSuperclass([self class])
    };
    // 这里直接调用objc_msgSendSuper会发生错误
    void(*objc_msgSendSuperCasted)(void *, SEL, id) = (void*)objc_msgSendSuper;
    
    objc_msgSendSuperCasted(&superClass, _cmd, newValue);
}

- (void)ls_addObserver:(NSObject *)observer forKey:(NSString *)key {
    Class cls = [self class];
    NSString* clsName = NSStringFromClass(cls);
    
    NSString* setKey = [NSString stringWithFormat:@"set%@%@:", [key substringToIndex:1].uppercaseString, [key substringFromIndex:1]];
    SEL setterSelector = NSSelectorFromString(setKey);
    Method setterMethod = class_getInstanceMethod(cls, setterSelector);
    const char* types = method_getTypeEncoding(setterMethod);
    
    // 动态创建一个类
    Class newClss = objc_allocateClassPair(cls, [NSString stringWithFormat:@"%@%@", kLsClassNamePrefix, clsName].UTF8String, 0);
    // 添加方法
    class_addMethod(newClss, setterSelector, (IMP)setMethod, types);
    
    objc_registerClassPair(newClss);
    // 替换isa指针
    object_setClass(self, newClss);
    
    // 记录
    NSMutableArray* servers = objc_getAssociatedObject(self, kKey.UTF8String);
    if (!servers) {
        servers = [NSMutableArray arrayWithCapacity:0];
        objc_setAssociatedObject(self, kKey.UTF8String, servers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    ObserverInfo* info = [[ObserverInfo alloc] initWithObserver:observer key:key];
    [servers addObject:info];
}

- (void)ls_removeObserver:(NSObject *)observer forKey:(NSString *)key {
    NSMutableArray* servers = objc_getAssociatedObject(self, kKey.UTF8String);
    ObserverInfo* info = nil;
    for (ObserverInfo* observerInfo in servers) {
        if (observerInfo.observer == observer && observerInfo.key == key) {
            info = observerInfo;
            break;
        }
    }
    [servers removeObject:info];
}

@end
