//
//  XJHNetFlowManager.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "XJHNetFlowManager.h"
#import "XJHURLProtocol.h"
#import "XJHNetFlowDataSource.h"
#import "XJHNetworkInterceptor.h"

@interface XJHNetFlowManager ()<XJHNetworkInterceptorDelegate>

@end


@implementation XJHNetFlowManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public Methods

- (void)canInterceptNetFlow:(BOOL)enable {
    _canIntercept = enable;
    if (enable) {
        [[XJHNetworkInterceptor sharedInstance] addDelegate:self];
        _startInterceptDate = [NSDate date];
    } else {
        [[XJHNetworkInterceptor sharedInstance] removeDelegate:self];
        _startInterceptDate = nil;
        [[XJHNetFlowDataSource sharedInstance] clear];
    }
}

#pragma mark - XJHNetworkInterceptorDelegate Methods

- (BOOL)shouldIntercept {
    return _canIntercept;
}

- (void)networkInterceptorDidReceiveData:(NSData *)data
                                response:(NSURLResponse *)response
                                 request:(NSURLRequest *)request
                                   error:(NSError *)error
                               startTime:(NSTimeInterval)startTime {
    XJHNetFlowHttpModel *httpModel = [XJHNetFlowHttpModel dealWithResponseData:data response:response request:request];
    if (!response) {
        httpModel.statusCode = error.localizedDescription;
    }
    httpModel.startTime = startTime;
    httpModel.endTime = [[NSDate date] timeIntervalSince1970];
    httpModel.totalDuration = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] - startTime];
    [[XJHNetFlowDataSource sharedInstance] addHttpModel:httpModel];
}



@end
