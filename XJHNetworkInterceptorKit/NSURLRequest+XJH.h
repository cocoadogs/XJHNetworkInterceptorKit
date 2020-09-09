//
//  NSURLRequest+XJH.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (XJH)

@property (nonatomic, copy) NSString *requestId;

@property (nonatomic, strong) NSNumber *startTime;

@property (nonatomic, assign) BOOL stop;

@end

NS_ASSUME_NONNULL_END
