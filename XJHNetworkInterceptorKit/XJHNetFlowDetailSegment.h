//
//  XJHNetFlowDetailSegment.h
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJHNetFlowDetailSegmentDelegate <NSObject>

- (void)segmentClick:(NSInteger)index;

@end

@interface XJHNetFlowDetailSegment : UIView

@property (nonatomic, weak) id<XJHNetFlowDetailSegmentDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
