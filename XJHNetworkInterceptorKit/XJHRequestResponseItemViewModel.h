//
//  XJHRequestResponseItemViewModel.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "XJHNetFlowHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJHRequestResponseItemViewModel : NSObject

- (instancetype)initWithModel:(XJHNetFlowHttpModel *)model;

@property (nonatomic, strong, readonly) XJHNetFlowHttpModel *model;

@property (nonatomic, assign, readonly) CGFloat height;

@property (nonatomic, strong, readonly) RACSubject *selectionSignal;

@property (nonatomic, strong, readonly) RACCommand *selectionCommand;

/// url信息
@property (nonatomic, copy, readonly) NSString *url;

/// 请求方法
@property (nonatomic, copy, readonly) NSString *method;

/// 请求状态
@property (nonatomic, copy, readonly) NSString *status;

/// 开始事件
@property (nonatomic, copy, readonly) NSString *start;

/// 花费时间
@property (nonatomic, copy, readonly) NSString *time;

/// 流量信息
@property (nonatomic, copy, readonly) NSString *flow;

@end

NS_ASSUME_NONNULL_END
