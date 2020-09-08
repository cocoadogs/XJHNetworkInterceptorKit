//
//  XJHNetFlowDetailSegment.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//

#import "XJHNetFlowDetailSegment.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//根据750*1334分辨率计算size
#define kXJHSizeFrom750(x) ((x)*SCREEN_WIDTH/750)
// 如果横屏显示
#define kXJHSizeFrom750_Landscape(x) (kInterfaceOrientationPortrait ? kXJHSizeFrom750(x) : ((x)*SCREEN_HEIGHT/750))

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

@interface XJHNetFlowDetailSegment ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *selectLine;

@end

@implementation XJHNetFlowDetailSegment

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        _leftLabel.textColor = [UIColor colorWithRed:51/255.0f green:124/255.0f blue:196/255.0f alpha:1];
        _leftLabel.font = [UIFont systemFontOfSize:kXJHSizeFrom750_Landscape(32)];
        _leftLabel.text = @"Request";
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_leftLabel];
        
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTap)];
        _leftLabel.userInteractionEnabled = YES;
        [_leftLabel addGestureRecognizer:leftTap];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
        _rightLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        _rightLabel.font = [UIFont systemFontOfSize:kXJHSizeFrom750_Landscape(32)];
        _rightLabel.text = @"Response";
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rightLabel];
        
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap)];
        _rightLabel.userInteractionEnabled = YES;
        [_rightLabel addGestureRecognizer:rightTap];
        
        _selectLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/4-kXJHSizeFrom750_Landscape(128)/2, self.frame.size.height-kXJHSizeFrom750_Landscape(4), kXJHSizeFrom750_Landscape(128), kXJHSizeFrom750_Landscape(4))];
        _selectLine.backgroundColor = [UIColor colorWithRed:51/255.0f green:124/255.0f blue:196/255.0f alpha:1];
        [self addSubview:_selectLine];
        
    }
    return self;
}

- (void)leftTap{
    if (_delegate && [_delegate respondsToSelector:@selector(segmentClick:)]) {
        [_delegate segmentClick:0];
    }
    _leftLabel.textColor = [UIColor colorWithRed:51/255.0f green:124/255.0f blue:196/255.0f alpha:1];
    _rightLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    _selectLine.frame = CGRectMake(self.frame.size.width/4-kXJHSizeFrom750_Landscape(128)/2, self.frame.size.height-kXJHSizeFrom750_Landscape(4), kXJHSizeFrom750_Landscape(128), kXJHSizeFrom750_Landscape(4));
}

- (void)rightTap{
    if (_delegate && [_delegate respondsToSelector:@selector(segmentClick:)]) {
        [_delegate segmentClick:1];
    }
    _leftLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    _rightLabel.textColor = [UIColor colorWithRed:51/255.0f green:124/255.0f blue:196/255.0f alpha:1];
    _selectLine.frame = CGRectMake(self.frame.size.width*3/4-kXJHSizeFrom750_Landscape(128)/2, self.frame.size.height-kXJHSizeFrom750_Landscape(4), kXJHSizeFrom750_Landscape(128), kXJHSizeFrom750_Landscape(4));
}

@end
