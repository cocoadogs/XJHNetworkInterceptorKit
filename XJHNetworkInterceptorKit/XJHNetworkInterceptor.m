//
//  XJHNetworkInterceptor.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "XJHNetworkInterceptor.h"
#import "XJHURLProtocol.h"

@interface XJHNetworkInterceptor ()

@property (nonatomic, strong) NSHashTable *delegates;

@end

@implementation XJHNetworkInterceptor

- (NSHashTable *)delegates {
    if (!_delegates) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public Methods

- (void)addDelegate:(id<XJHNetworkInterceptorDelegate>)delegate {
    [self.delegates addObject:delegate];
    [self updateURLProtocolInterceptStatus];
}

- (void)removeDelegate:(id<XJHNetworkInterceptorDelegate>)delegate {
    [self.delegates removeObject:delegate];
    [self updateURLProtocolInterceptStatus];
}

- (void)updateInterceptStatusForSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration {
    if ([sessionConfiguration respondsToSelector:@selector(protocolClasses)]
        && [sessionConfiguration respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: sessionConfiguration.protocolClasses];
        Class protoCls = XJHURLProtocol.class;
        if ( ![urlProtocolClasses containsObject: protoCls]) {
            [urlProtocolClasses insertObject: protoCls atIndex: 0];
        } else if ([urlProtocolClasses containsObject: protoCls]) {
            [urlProtocolClasses removeObject: protoCls];
        }
        sessionConfiguration.protocolClasses = urlProtocolClasses;
    }
}

- (void)handleResultWithData:(NSData *)data
                    response:(NSURLResponse *)response
                     request:(NSURLRequest *)request
                       error:(NSError *)error
                   startTime:(NSTimeInterval)startTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<XJHNetworkInterceptorDelegate> delegate in self.delegates) {
            [delegate networkInterceptorDidReceiveData:data response:response request:request error:error startTime:startTime];
        }
    });
}

#pragma mark - Getter Methods

- (BOOL)shouldIntercept {
    // 当有对象监听 拦截后的网络请求时，才需要拦截
    BOOL shouldIntercept = NO;
    for (id<XJHNetworkInterceptorDelegate> delegate in self.delegates) {
        if (delegate.shouldIntercept) {
            shouldIntercept = YES;
            break;
        }
    }
    return shouldIntercept;
}

#pragma mark - Private Methods

- (void)updateURLProtocolInterceptStatus {
    if (self.shouldIntercept) {
        [NSURLProtocol registerClass:[XJHURLProtocol class]];
    }else{
        [NSURLProtocol unregisterClass:[XJHURLProtocol class]];
    }
}


@end
