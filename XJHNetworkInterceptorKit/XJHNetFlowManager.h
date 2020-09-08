//
//  XJHNetFlowManager.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHNetFlowManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSDate *startInterceptDate;
@property (nonatomic, assign) BOOL canIntercept;

- (void)canInterceptNetFlow:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
