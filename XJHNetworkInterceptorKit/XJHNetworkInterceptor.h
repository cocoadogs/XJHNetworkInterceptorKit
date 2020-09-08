//
//  XJHNetworkInterceptor.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJHNetworkInterceptorDelegate <NSObject>

- (BOOL)shouldIntercept;

- (void)networkInterceptorDidReceiveData:(NSData *)data
                                response:(NSURLResponse *)response
                                 request:(NSURLRequest *)request
                                   error:(NSError *)error
                               startTime:(NSTimeInterval)startTime;

@end


@interface XJHNetworkInterceptor : NSObject

@property (nonatomic, assign) BOOL shouldIntercept;

+ (instancetype)sharedInstance;

- (void)addDelegate:(id<XJHNetworkInterceptorDelegate>)delegate;
- (void)removeDelegate:(id<XJHNetworkInterceptorDelegate>)delegate;
- (void)updateInterceptStatusForSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;
- (void)handleResultWithData:(NSData *)data
                    response:(NSURLResponse *)response
                     request:(NSURLRequest *)request
                       error:(NSError *)error
                   startTime:(NSTimeInterval)startTime;


@end

NS_ASSUME_NONNULL_END
