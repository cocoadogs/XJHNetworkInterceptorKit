//
//  XJHRequestResponseViewModel.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/7.
//

#import "XJHRequestResponseViewModel.h"
#import "XJHNetFlowDataSource.h"

@interface XJHRequestResponseViewModel ()

@property (nonatomic, copy) NSArray<XJHRequestResponseItemViewModel *> *items;

@property (nonatomic, strong) RACCommand *clearCommand;

@property (nonatomic, strong) RACSubject *selectionSignal;

@end

@implementation XJHRequestResponseViewModel

#pragma mark - Init Methods

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setFilters:(NSArray<NSString *> *)filters {
    _filters = filters;
    [self initialize];
}

#pragma mark - Private Methods

- (void)initialize {
    NSArray<XJHNetFlowHttpModel *> *list = [XJHNetFlowDataSource sharedInstance].httpModelArray;
    NSMutableArray<XJHRequestResponseItemViewModel *> *mItems = [[NSMutableArray<XJHRequestResponseItemViewModel *> alloc] initWithCapacity:list.count];
    for (XJHNetFlowHttpModel *item in list) {
        __block BOOL checked = NO;
        if (_filters.count == 0) {
            checked = YES;
        } else {
            [_filters enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self afterTrim:obj].length > 0) {
                    if ([item.url containsString:[self afterTrim:obj]]) {
                        checked = YES;
                        *stop = YES;
                    }
                }
            }];
        }
        if (checked) {
            XJHRequestResponseItemViewModel *vm = [[XJHRequestResponseItemViewModel alloc] initWithModel:item];
            @weakify(self)
            [vm.selectionSignal subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.selectionSignal sendNext:x];
            }];
            !vm?:[mItems addObject:vm];
        }
    }
    self.items = mItems;
}

- (NSString *)afterTrim:(NSString *)string {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [[string stringByTrimmingCharactersInSet:set] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - Property Methods

- (RACSubject *)selectionSignal {
    if (!_selectionSignal) {
        _selectionSignal = [RACSubject subject];
    }
    return _selectionSignal;
}

- (RACCommand *)clearCommand {
    if (!_clearCommand) {
        @weakify(self)
        _clearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [[XJHNetFlowDataSource sharedInstance] clear];
                self.items = nil;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _clearCommand;
}


@end
