//
//  XJHRequestResponseViewModel.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "XJHRequestResponseItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJHRequestResponseViewModel : NSObject

@property (nonatomic, copy) NSArray<NSString *> *filters;

@property (nonatomic, copy, readonly) NSArray<XJHRequestResponseItemViewModel *> *items;

@property (nonatomic, strong, readonly) RACCommand *clearCommand;

@property (nonatomic, strong, readonly) RACSubject *selectionSignal;


@end

NS_ASSUME_NONNULL_END
