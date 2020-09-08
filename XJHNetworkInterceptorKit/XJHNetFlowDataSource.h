//
//  XJHNetFlowDataSource.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import "XJHNetFlowHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJHNetFlowDataSource : NSObject

@property (nonatomic, strong) NSMutableArray<XJHNetFlowHttpModel *> *httpModelArray;

+ (instancetype)sharedInstance;

- (void)addHttpModel:(XJHNetFlowHttpModel *)httpModel;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
