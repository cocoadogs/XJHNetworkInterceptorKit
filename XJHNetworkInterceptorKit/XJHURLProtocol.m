//
//  XJHURLProtocol.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "XJHURLProtocol.h"
#import "XJHNetFlowHttpModel.h"
#import "XJHNetFlowManager.h"
#import "XJHURLSessionDemux.h"
#import "XJHNetworkInterceptor.h"

static NSString * const kXJHURLProtocolKey = @"xjhurl_protocol_key";

@interface XJHURLProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;

@property (atomic, strong) NSThread *clientThread;
@property (atomic, copy) NSArray *modes;
@property (atomic, strong) NSURLSessionDataTask *task;

@end

@implementation XJHURLProtocol

+ (XJHURLSessionDemux *)sharedDemux {
    static XJHURLSessionDemux *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        sharedInstance = [[XJHURLSessionDemux alloc] initWithConfiguration:config];
    });
    return sharedInstance;
}

#pragma mark - Override Methods

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return request == nil ? NO : [self canInitWithRequest:request];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:kXJHURLProtocolKey inRequest:request]) {
        return NO;
    }
    if (![XJHNetworkInterceptor sharedInstance].shouldIntercept) {
        return NO;
    }
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    //文件类型不作处理
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    if (contentType && [contentType containsString:@"multipart/form-data"]) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:kXJHURLProtocolKey inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)startLoading {
    NSMutableURLRequest *   recursiveRequest;
    NSMutableArray *        calculatedModes;
    NSString *              currentMode;
    
    NSAssert(!(self.clientThread || self.task || self.modes), @"XJHURLProtocol:clientThread or task or modes is not nil");
    
    calculatedModes = [NSMutableArray array];
    [calculatedModes addObject:NSDefaultRunLoopMode];
    currentMode = [[NSRunLoop currentRunLoop] currentMode];
    if ( (currentMode != nil) && ! [currentMode isEqual:NSDefaultRunLoopMode] ) {
        [calculatedModes addObject:currentMode];
    }
    self.modes = calculatedModes;
    
    NSAssert(self.modes.count > 0, @"XJHURLProtocol:self.modes is empty");
    
    recursiveRequest = [[self request] mutableCopy];
    
    NSAssert(recursiveRequest, @"XJHURLProtocol:recursiveRequest is nil");
    
    self.clientThread = [NSThread currentThread];
    self.data = [NSMutableData data];
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.task = [[[self class] sharedDemux] dataTaskWithRequest:recursiveRequest delegate:self modes:self.modes];
    
    NSAssert(self.task, @"XJHURLProtocol:task is nil");
    
    [self.task resume];
}

- (void)stopLoading {
    NSAssert(self.clientThread && [NSThread currentThread] == self.clientThread, @"XJHURLProtocol: self.clientThread is nil or self.clientThread is not current thread");
    
    [[XJHNetworkInterceptor sharedInstance] handleResultWithData:self.data
                                                        response:self.response
                                                         request:self.request
                                                           error:self.error
                                                       startTime:self.startTime];
    
    if (self.task != nil) {
        [self.task cancel];
        self.task = nil;
    }
}

#pragma mark - Private Methods

#pragma mark - NSURLSessionDataDelegate Methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSAssert([NSThread currentThread] == self.clientThread, @"self.clientThread is not current thread");
    self.response = response;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSAssert([NSThread currentThread] == self.clientThread, @"self.clientThread is not current thread");
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSAssert([NSThread currentThread] == self.clientThread, @"self.clientThread is not current thread");
    //判断服务器返回的证书类型, 是否是服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //强制信任
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        self.error = error;
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}


@end
