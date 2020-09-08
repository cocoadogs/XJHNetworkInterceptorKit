//
//  XJHRequestResponseSearchViewController.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//

#import <UIKit/UIKit.h>
#import "XJHRequestResponseItemViewModel.h"

typedef void(^XJHRequestResponseSearchCallback)(id object);

@interface XJHRequestResponseSearchViewController : UIViewController

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) XJHRequestResponseSearchCallback callback;

@property (nonatomic, copy) NSArray<XJHRequestResponseItemViewModel *> *items;

- (void)reset;


@end
