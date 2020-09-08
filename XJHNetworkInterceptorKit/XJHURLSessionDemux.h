//
//  XJHURLSessionDemux.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHURLSessionDemux : NSObject

- (instancetype)initWithConfiguration:(nullable NSURLSessionConfiguration *)configuration;

@property (atomic, strong, readonly) NSURLSessionConfiguration *configuration;

@property (atomic, strong, readonly) NSURLSession *session;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes;

@end

NS_ASSUME_NONNULL_END
