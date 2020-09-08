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

/*Controller*/
#import <XJHNetworkInterceptorKit/XJHRequestResponseViewController.h>


#else

/*Model*/
#import "XJHNetFlowHttpModel.h"

/*Manager*/
#import "XJHNetFlowManager.h"

/*DataSource*/
#import "XJHNetFlowDataSource.h"

/*Controller*/
#import "XJHRequestResponseViewController.h"

#endif /* __has_include */
#endif /* XJHNetworkInterceptorKit_h */
