//
//  NSObject+XJHSwizzle.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//

#import "NSObject+XJHSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (XJHSwizzle)

+ (void)xjh_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:cls];
}

+ (void)xjh_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

@end
