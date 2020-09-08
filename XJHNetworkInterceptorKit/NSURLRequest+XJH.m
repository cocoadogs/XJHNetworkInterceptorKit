//
//  NSURLRequest+XJH.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "NSURLRequest+XJH.h"
#import <objc/runtime.h>


@implementation NSURLRequest (XJH)

- (NSString *)requestId {
    return objc_getAssociatedObject(self, @selector(requestId));
}

- (void)setRequestId:(NSString *)requestId {
    objc_setAssociatedObject(self, @selector(requestId), requestId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)startTime {
    return objc_getAssociatedObject(self, @selector(startTime));
}

- (void)setStartTime:(NSNumber *)startTime {
    objc_setAssociatedObject(self, @selector(startTime), startTime, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
