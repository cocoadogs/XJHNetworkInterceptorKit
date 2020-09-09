//
//  XJHNetworkInterceptorKit.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#ifndef XJHNetworkInterceptorKit_h
#define XJHNetworkInterceptorKit_h

#if __has_include(<XJHNetworkInterceptorKit/XJHNetworkInterceptorKit.h>)

/*Model*/
#import <XJHNetworkInterceptorKit/XJHNetFlowHttpModel.h>

/*Manager*/
#import <XJHNetworkInterceptorKit/XJHNetFlowManager.h>

/*DataSource*/
#import <XJHNetworkInterceptorKit/XJHNetFlowDataSource.h>

/*Util*/
#import <XJHNetworkInterceptorKit/XJHUrlUtil.h>
#import <XJHNetworkInterceptorKit/NSURLRequest+XJH.h>
#import <XJHNetworkInterceptorKit/NSObject+XJHSwizzle.h>

/*ViewModel*/
#import <XJHNetworkInterceptorKit/XJHRequestResponseItemViewModel.h>

/*Cell*/
#import <XJHNetworkInterceptorKit/XJHNetworkInterceptorViewCell.h>

/*Controller*/
#import <XJHNetworkInterceptorKit/XJHRequestResponseViewController.h>
#import <XJHNetworkInterceptorKit/XJHRequestResponseDetailViewController.h>

#else

/*Model*/
#import "XJHNetFlowHttpModel.h"

/*Manager*/
#import "XJHNetFlowManager.h"

/*DataSource*/
#import "XJHNetFlowDataSource.h"

/*Util*/
#import "XJHUrlUtil.h"
#import "NSURLRequest+XJH.h"
#import "NSObject+XJHSwizzle.h"

/*ViewModel*/
#import "XJHRequestResponseItemViewModel.h"

/*Cell*/
#import "XJHNetworkInterceptorViewCell.h"

/*Controller*/
#import "XJHRequestResponseViewController.h"
#import "XJHRequestResponseDetailViewController.h"

#endif /* __has_include */
#endif /* XJHNetworkInterceptorKit_h */
