//
//  XJHNetworkInterceptorViewCell.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//
// cocoadogs@163.com

#import "XJHNetworkInterceptorViewCell.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

static CGFloat const kNetworkInterceptorFontSize = 10;

@interface XJHNetworkInterceptorViewCell()

@property (nonatomic, strong) UILabel *urlLabel;//url信息
@property (nonatomic, strong) UILabel *methodLabel;//请求方式
@property (nonatomic, strong) UILabel *statusLabel;//请求状态
@property (nonatomic, strong) UILabel *startTimeLabel;//请求开始时间
@property (nonatomic, strong) UILabel *timeLabel;//请求耗时
@property (nonatomic, strong) UILabel *flowLabel;//流量信息
@property (nonatomic, strong) UIButton *selectionBtn;

@end

@implementation XJHNetworkInterceptorViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// - (void)setFrame:(CGRect)frame {
//     frame.origin.x += 20;
//     frame.size.width -= 40;
//     [super setFrame:frame];
// }

#pragma mark - Init Method

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self buildUI];
	}
	return self;
}

#pragma mark - Public Method

- (void)setViewModel:(XJHRequestResponseItemViewModel *)viewModel {
    _viewModel = viewModel;
    self.selectionBtn.rac_command = self.viewModel.selectionCommand;
    [self render];
}

#pragma mark - Private Methods

- (void)render {
    CGFloat startY = 5,startX = 10;
    NSString *urlString = self.viewModel.url;
    if (urlString.length > 0){
        self.urlLabel.text = urlString;
        CGSize size = [self.urlLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX)];
        self.urlLabel.frame = CGRectMake(startX, startY, SCREEN_WIDTH-40, size.height);
        startY += self.urlLabel.frame.size.height + 2;
    }
    
    CGFloat height = 0;
    NSString *method = self.viewModel.method;
    NSString *status = self.viewModel.status;
    if (method.length > 0) {
        self.methodLabel.text = method;
        [self.methodLabel sizeToFit];
        self.methodLabel.frame = CGRectMake(10, startY, self.methodLabel.frame.size.width, self.methodLabel.frame.size.height);
        startX = CGRectGetMaxX(self.methodLabel.frame) + 5;
        height = self.methodLabel.frame.size.height;
    }
    if (status.length>0) {
        self.statusLabel.text = status;
        [self.statusLabel sizeToFit];
        self.statusLabel.frame = CGRectMake(startX, CGRectGetMaxY(self.urlLabel.frame) + 2, self.statusLabel.frame.size.width, self.statusLabel.frame.size.height);
        height = self.statusLabel.frame.size.height;
    }
    if (method.length > 0 || status.length > 0) {
        startY += height + 2;
    }
    
    startX = 10;
    
    NSString *start = self.viewModel.start;
    NSString *time = self.viewModel.time;
    if (start.length > 0) {
        self.startTimeLabel.text = start;
        [self.startTimeLabel sizeToFit];
        self.startTimeLabel.frame = CGRectMake(startX, startY, self.startTimeLabel.frame.size.width, self.startTimeLabel.frame.size.height);
        startX = CGRectGetMaxX(self.startTimeLabel.frame) + 5;
        height = self.startTimeLabel.frame.size.height;
    }
    if (time.length > 0) {
        self.timeLabel.text = time;
        [self.timeLabel sizeToFit];
        self.timeLabel.frame = CGRectMake(startX, startY, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
        height = self.startTimeLabel.frame.size.height;
    }
    
    if (start.length > 0 || time.length > 0) {
        startY += height + 2;
    }
    startX = 10;
    
    if (self.viewModel.flow.length > 0) {
        self.flowLabel.text = self.viewModel.flow;
        [self.flowLabel sizeToFit];
        self.flowLabel.frame = CGRectMake(startX, startY, self.flowLabel.frame.size.width, self.flowLabel.frame.size.height);
    }
    
    self.selectionBtn.frame = self.contentView.bounds;
}

#pragma mark - UI Build Method

- (void)buildUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.urlLabel = [[UILabel alloc] init];
    self.urlLabel.font = [UIFont systemFontOfSize:kNetworkInterceptorFontSize];
    
    self.urlLabel.numberOfLines = 0;
    [self.contentView addSubview:self.urlLabel];
    
    self.methodLabel = [[UILabel alloc] init];
    self.methodLabel.font = [UIFont systemFontOfSize:kNetworkInterceptorFontSize];
    self.methodLabel.textColor = [UIColor whiteColor];
    self.methodLabel.backgroundColor = [UIColor colorWithRed:0.82 green:0.38 blue:0.51 alpha:1];
    self.methodLabel.layer.cornerRadius = 2;
    self.methodLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.methodLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:kNetworkInterceptorFontSize];
    
    [self.contentView addSubview:self.statusLabel];
    
    self.startTimeLabel = [[UILabel alloc] init];
    self.startTimeLabel.font = [UIFont systemFontOfSize:kNetworkInterceptorFontSize];
    
    [self.contentView addSubview:self.startTimeLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:kNetworkInterceptorFontSize];
    
    [self.contentView addSubview:self.timeLabel];
    
    self.flowLabel = [[UILabel alloc] init];
    self.flowLabel.font = [UIFont systemFontOfSize:kNetworkInterceptorFontSize];
    [self.contentView addSubview:self.flowLabel];
    if (@available(iOS 13.0, *)) {
        self.urlLabel.textColor = [UIColor labelColor];
        self.statusLabel.textColor = [UIColor labelColor];
        self.startTimeLabel.textColor = [UIColor labelColor];
        self.timeLabel.textColor = [UIColor labelColor];
        self.flowLabel.textColor = [UIColor labelColor];
    } else {
        self.urlLabel.textColor = [UIColor blackColor];
        self.statusLabel.textColor = [UIColor blackColor];
        self.startTimeLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.flowLabel.textColor = [UIColor blackColor];
    }
    [self.contentView addSubview:self.selectionBtn];
    [self.contentView sendSubviewToBack:self.selectionBtn];
    
}

#pragma mark - Property Methods

- (UIButton *)selectionBtn {
    if (!_selectionBtn) {
        _selectionBtn = [[UIButton alloc] init];
        [_selectionBtn setTitle:@"" forState:UIControlStateNormal];
        UIImage *bgImage = ({
            CGRect rect = CGRectMake(0, 0, 1, 1);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
            CGContextFillRect(context, rect);
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            img;
        });
        [_selectionBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_selectionBtn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    }
    return _selectionBtn;
}

@end
