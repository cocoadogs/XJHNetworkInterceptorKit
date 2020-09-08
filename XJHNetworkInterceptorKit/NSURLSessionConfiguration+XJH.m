//
//  NSURLSessionConfiguration+XJH.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//

#import "NSURLSessionConfiguration+XJH.h"
#import "NSObject+XJHSwizzle.h"
#import "XJHURLProtocol.h"

@implementation NSURLSessionConfiguration (XJH)

+ (void)load{
    [[self class] xjh_swizzleClassMethodWithOriginSel:@selector(defaultSessionConfiguration) swizzledSel:@selector(xjh_defaultSessionConfiguration)];
    [[self class] xjh_swizzleClassMethodWithOriginSel:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(xjh_ephemeralSessionConfiguration)];
}

+ (NSURLSessionConfiguration *)xjh_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self xjh_defaultSessionConfiguration];
    [configuration addDoraemonNSURLProtocol];
    return configuration;
}

+ (NSURLSessionConfiguration *)xjh_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self xjh_ephemeralSessionConfiguration];
    [configuration addDoraemonNSURLProtocol];
    return configuration;
}

- (void)addDoraemonNSURLProtocol {
    if ([self respondsToSelector:@selector(protocolClasses)]
        && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: self.protocolClasses];
        Class protoCls = XJHURLProtocol.class;
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}

@end
