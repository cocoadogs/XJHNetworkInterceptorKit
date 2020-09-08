//
//  XJHRequestResponseItemViewModel.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "XJHRequestResponseItemViewModel.h"
#import "XJHUrlUtil.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

@interface XJHRequestResponseItemViewModel ()

@property (nonatomic, strong) XJHNetFlowHttpModel *model;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) RACSubject *selectionSignal;

@property (nonatomic, strong) RACCommand *selectionCommand;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *method;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *start;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *flow;

@end

@implementation XJHRequestResponseItemViewModel

#pragma mark - Init Methods

- (instancetype)initWithModel:(XJHNetFlowHttpModel *)model {
    if (self = [super init]) {
        self.model = model;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.url = self.model.url;
    self.method = ({
        NSString *string = @"";
        if (self.model.mineType.length > 0) {
            string = [NSString stringWithFormat:@" %@ > %@", self.model.method, self.model.mineType];
        } else {
            string = [NSString stringWithFormat:@" %@ ", self.model.method];
        }
        string;
    });
    self.status = ({
        NSString *string = @"";
        if (self.model.statusCode.length > 0) {
            string = [NSString stringWithFormat:@"[%@]", self.model.statusCode];
        }
        string;
    });
    self.start = [XJHUrlUtil dateFormatTimeInterval:self.model.startTime];
    self.time = [NSString stringWithFormat:@"cost:%@", self.model.totalDuration];
    self.flow = ({
        NSString *uploadFlow = [XJHUrlUtil formatByte:[self.model.uploadFlow floatValue]];
        NSString *downFlow = [XJHUrlUtil formatByte:[self.model.downFlow floatValue]];
        NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
        if (uploadFlow.length>0) {
            [string appendString:[NSString stringWithFormat:@"↑ %@",uploadFlow]];
        }
        if (downFlow.length>0) {
            [string appendString:[NSString stringWithFormat:@"↓ %@",downFlow]];
        }
        string;
    });
}

#pragma mark - Getter Methods

- (CGFloat)height {
    CGFloat height = 5;
    
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.font = [UIFont systemFontOfSize:10];
    NSString *urlString = self.model.url;
    if (urlString.length > 0) {
        tempLabel.numberOfLines = 0;
        tempLabel.text = urlString;
        CGSize size = [tempLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX)];
        height += size.height;
        height += 2;
    }
    
    NSString *method = self.model.method;
    NSString *status = self.model.statusCode;
    if (method.length > 0 || status.length > 0) {
        tempLabel.numberOfLines = 1;
        tempLabel.text = @"Hello";
        [tempLabel sizeToFit];
        
        height += tempLabel.frame.size.height;
        height += 2;
    }
    
    NSString *startTime = [XJHUrlUtil dateFormatTimeInterval:self.model.startTime];
    NSString *time = self.model.totalDuration;
    if (startTime.length > 0 || time.length > 0) {
        tempLabel.numberOfLines = 1;
        tempLabel.text = @"Hello";
        [tempLabel sizeToFit];
        height += tempLabel.frame.size.height;
        height += 2;
    }
    
    NSString *uploadFlow = self.model.uploadFlow;
    NSString *downFlow = self.model.downFlow;
    if (uploadFlow.length > 0 || downFlow.length > 0) {
        tempLabel.numberOfLines = 1;
        tempLabel.text = @"Hello";
        [tempLabel sizeToFit];
        height += tempLabel.frame.size.height;
        height += 2;
    }
    
    height += 3;
    
    return height;
}

#pragma mark - Property Methods

- (RACSubject *)selectionSignal {
    if (!_selectionSignal) {
        _selectionSignal = [RACSubject subject];
    }
    return _selectionSignal;
}

- (RACCommand *)selectionCommand {
    if (!_selectionCommand) {
        @weakify(self)
        _selectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [self.selectionSignal sendNext:self.model];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _selectionCommand;
}

@end
