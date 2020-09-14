//
//  XJHURLSessionDemux.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "XJHURLSessionDemux.h"

@interface XJHURLSessionDemuxTaskInfo : NSObject

- (instancetype)initWithTask:(NSURLSessionDataTask *)task delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes;

@property (atomic, strong, readonly) NSURLSessionDataTask *task;
@property (atomic, strong, readonly) id<NSURLSessionDataDelegate> delegate;
@property (atomic, strong, readonly) NSThread *thread;
@property (atomic, copy, readonly) NSArray *modes;

- (void)performBlock:(dispatch_block_t)block;

- (void)invalidate;

@end

@interface XJHURLSessionDemuxTaskInfo ()

@property (atomic, strong) id<NSURLSessionDataDelegate> delegate;
@property (atomic, strong) NSThread *thread;

@end


@implementation XJHURLSessionDemuxTaskInfo

- (instancetype)initWithTask:(NSURLSessionDataTask *)task delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes {
    
    self = [super init];
    if (self != nil) {
        self->_task = task;
        self->_delegate = delegate;
        self->_thread = [NSThread currentThread];
        self->_modes = [modes copy];
    }
    return self;
}

- (void)performBlock:(dispatch_block_t)block {
    [self performSelector:@selector(performBlockOnClientThread:) onThread:self.thread withObject:[block copy] waitUntilDone:NO modes:self.modes];
}

- (void)performBlockOnClientThread:(dispatch_block_t)block {
    block();
}

- (void)invalidate {
    self.delegate = nil;
    self.thread = nil;
}

@end

@interface XJHURLSessionDemux ()<NSURLSessionDataDelegate>

@property (atomic, strong, readonly) NSMutableDictionary *taskInfoByTaskID;
@property (atomic, strong, readonly) NSOperationQueue *sessionDelegateQueue;

@end

@implementation XJHURLSessionDemux

#pragma mark - Init Methods

- (instancetype)init{
    return [self initWithConfiguration:nil];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration{
    self = [super init];
    if (self != nil) {
        if (configuration == nil) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self->_configuration = [configuration copy];
        
        self->_taskInfoByTaskID = [[NSMutableDictionary alloc] init];
        self->_sessionDelegateQueue = [[NSOperationQueue alloc] init];
        [self->_sessionDelegateQueue setMaxConcurrentOperationCount:1];
        [self->_sessionDelegateQueue setName:@"XJHURLSessionDemux"];
        
        self->_session = [NSURLSession sessionWithConfiguration:self->_configuration delegate:self delegateQueue:self->_sessionDelegateQueue];
        self->_session.sessionDescription = @"XJHURLSessionDemux";
    }
    return self;
}

#pragma mark - Public Methods

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes {
    
    NSURLSessionDataTask *task;
    XJHURLSessionDemuxTaskInfo *taskInfo;
    
    if ([modes count] == 0) {
        modes = @[NSDefaultRunLoopMode];
    }
    
    task = [self.session dataTaskWithRequest:request];
    taskInfo = [[XJHURLSessionDemuxTaskInfo alloc] initWithTask:task delegate:delegate modes:modes];
    
    if (task && taskInfo) {
        @synchronized (self) {
            self.taskInfoByTaskID[@(task.taskIdentifier)] = taskInfo;
        }
    }
    
    return task;
}

- (XJHURLSessionDemuxTaskInfo *)taskInfoForTask:(NSURLSessionTask *)task {
    XJHURLSessionDemuxTaskInfo *result;
    if (task) {
        @synchronized (self) {
            result = self.taskInfoByTaskID[@(task.taskIdentifier)];
        }
    }
    return result;
}

#pragma mark - NSURLSessionDataDelegate Methods

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler {
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task willPerformHTTPRedirection:response newRequest:newRequest completionHandler:completionHandler];
        }];
    } else {
        completionHandler(newRequest);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didReceiveChallenge:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
        }];
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:needNewBodyStream:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task needNewBodyStream:completionHandler];
        }];
    } else {
        completionHandler(nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:task];
    @synchronized (self) {
        [self.taskInfoByTaskID removeObjectForKey:@(taskInfo.task.taskIdentifier)];
    }
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didCompleteWithError:error];
            [taskInfo invalidate];
        }];
    } else {
        [taskInfo invalidate];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
        }];
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didBecomeDownloadTask:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveData:data];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    XJHURLSessionDemuxTaskInfo *taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:willCacheResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
        }];
    } else {
        completionHandler(proposedResponse);
    }
}

@end
