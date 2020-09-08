//
//  XJHNetFlowDetailViewCell.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//

#import "XJHNetFlowDetailViewCell.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//根据750*1334分辨率计算size
#define kXJHSizeFrom750(x) ((x)*SCREEN_WIDTH/750)
// 如果横屏显示
#define kXJHSizeFrom750_Landscape(x) (kInterfaceOrientationPortrait ? kXJHSizeFrom750(x) : ((x)*SCREEN_HEIGHT/750))

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

@interface XJHNetFlowDetailViewCell ()

@property (nonatomic, strong) UITextView *contentLabel;
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;

@end

@implementation XJHNetFlowDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 禁用 UITextView 滑动，解决其与 UITableView 的滑动冲突；
    // 放这里调用是因为在其他地方调用会出现文本未显示的问题(模拟器环境下)
    _contentLabel.scrollEnabled = false;
}

#pragma mark - Init Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        //大文本显示的时候，UIlabel在模拟器上会显示空白，使用TextView代替。
        //网上相似问题： https://blog.csdn.net/minghuyong2016/article/details/82882314
        _contentLabel = [XJHNetFlowDetailViewCell genTextView:16.0];
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [UIColor systemBackgroundColor];
            _contentLabel.textColor = [UIColor labelColor];
        } else {
            _contentLabel.textColor = [UIColor blackColor];
        }
        _contentLabel.editable = NO;
        [self.contentView addSubview:_contentLabel];
        
        _upLine = [[UIView alloc] init];
        _upLine.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        [self.contentView addSubview:_upLine];
        _upLine.hidden = YES;
        
        _downLine = [[UIView alloc] init];
        _downLine.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        [self.contentView addSubview:_downLine];
        _downLine.hidden = YES;
    }
    return self;
}

#pragma mark - Public Methods

- (void)renderUIWithContent:(NSString *)content isFirst:(BOOL)isFirst isLast:(BOOL)isLast{
    _contentLabel.text = content;
    CGSize fontSize = [_contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-kXJHSizeFrom750_Landscape(32)*2, MAXFLOAT)];
    _contentLabel.frame = CGRectMake(kXJHSizeFrom750_Landscape(32), kXJHSizeFrom750_Landscape(28), fontSize.width, fontSize.height);
    
    CGFloat cellHeight = [[self class] cellHeightWithContent:content];
    if(isFirst && isLast){
        _upLine.hidden = NO;
        _upLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        _downLine.hidden = NO;
        _downLine.frame = CGRectMake(0, cellHeight-0.5, SCREEN_WIDTH, 0.5);
    }else if(isFirst && !isLast){
        _upLine.hidden = NO;
        _upLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        _downLine.hidden = NO;
        _downLine.frame = CGRectMake(20, cellHeight-0.5, SCREEN_WIDTH-20, 0.5);
    }else if(!isFirst && isLast){
        _upLine.hidden = YES;
        _downLine.hidden = NO;
        _downLine.frame = CGRectMake(0, cellHeight-0.5, SCREEN_WIDTH, 0.5);
    }else{
        _upLine.hidden = YES;
        _downLine.hidden = NO;
        _downLine.frame = CGRectMake(20, cellHeight-0.5, SCREEN_WIDTH-20, 0.5);
    }
}

+ (CGFloat)cellHeightWithContent:(NSString *)content{
    UITextView *tempLabel = [XJHNetFlowDetailViewCell genTextView:16.0];
    tempLabel.text = content;
    CGSize fontSize = [tempLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-2*kXJHSizeFrom750_Landscape(32), MAXFLOAT)];
    return fontSize.height+kXJHSizeFrom750_Landscape(28)*2;
}

#pragma mark - Private Methods

/// 生成 UITextView
+ (UITextView *)genTextView:(CGFloat)fontSize {
    UITextView *tempTextView = [[UITextView alloc] init];
    tempTextView.font = [UIFont systemFontOfSize:fontSize];
    return tempTextView;
}

@end
