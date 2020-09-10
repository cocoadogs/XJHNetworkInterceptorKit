//
//  XJHNetFlowDetailViewCell.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHNetFlowDetailViewCell : UITableViewCell

- (void)renderUIWithContent:(NSString *)content isFirst:(BOOL)isFirst isLast:(BOOL)isLast;

@end

NS_ASSUME_NONNULL_END
