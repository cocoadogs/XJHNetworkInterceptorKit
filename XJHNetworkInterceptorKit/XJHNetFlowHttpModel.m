//
//  XJHNetFlowHttpModel.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "XJHNetFlowHttpModel.h"
#import "NSURLRequest+XJH.h"
#import "XJHUrlUtil.h"

@implementation XJHNetFlowHttpModel

+ (XJHNetFlowHttpModel *)dealWithResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(NSURLRequest *)request {
    XJHNetFlowHttpModel *httpModel = [[XJHNetFlowHttpModel alloc] init];
    
    //request
    httpModel.request = request;
    httpModel.requestId = request.requestId;
    httpModel.url = [request.URL absoluteString];
    httpModel.method = request.HTTPMethod;
    NSData *httpBody = [XJHUrlUtil getHttpBodyFromRequest:request];
    httpModel.requestBody = [XJHUrlUtil convertJsonFromData:httpBody];
    
    httpModel.uploadFlow = [NSString stringWithFormat:@"%zi",[XJHUrlUtil getRequestLength:request]];
    
    //response
    httpModel.mineType = response.MIMEType;
    httpModel.response = response;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    httpModel.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    httpModel.responseData = responseData;
    httpModel.responseBody = [XJHUrlUtil convertJsonFromData:responseData];
    httpModel.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - request.startTime.doubleValue];
    httpModel.downFlow = [NSString stringWithFormat:@"%lli",[XJHUrlUtil getResponseLength:(NSHTTPURLResponse *)response data:responseData]];
    
    return httpModel;
}

@end
