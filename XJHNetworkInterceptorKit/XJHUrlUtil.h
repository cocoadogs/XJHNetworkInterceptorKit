//
//  XJHUrlUtil.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHUrlUtil : NSObject

+ (NSString *)convertJsonFromData:(NSData *)data;

+ (NSDictionary *)convertDicFromData:(NSData *)data;

+ (NSUInteger)getRequestLength:(NSURLRequest *)request;

+ (NSUInteger)getHeadersLength:(NSDictionary *)headers ;

+ (NSDictionary<NSString *, NSString *> *)getCookies:(NSURLRequest *)request ;

+ (int64_t)getResponseLength:(NSHTTPURLResponse *)response data:(NSData *)responseData;

+ (NSData *)getHttpBodyFromRequest:(NSURLRequest *)request;



+ (NSString *)dateFormatTimeInterval:(NSTimeInterval)timeInterval;

// byte格式化为 B KB MB 方便流量查看
+ (NSString *)formatByte:(CGFloat)byte;



@end

NS_ASSUME_NONNULL_END
