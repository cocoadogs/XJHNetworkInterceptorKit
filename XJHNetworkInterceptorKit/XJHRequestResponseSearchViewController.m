//
//  XJHRequestResponseSearchViewController.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//
// cocoadogs@163.com

#import "XJHRequestResponseSearchViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "XJHNetworkInterceptorViewCell.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

@interface XJHRequestResponseSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray<XJHRequestResponseItemViewModel *> *result;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XJHRequestResponseSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self buildUI];
	[self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
                self.automaticallyAdjustsScrollViewInsets = 0;
            }
        }
    }
    return self;
}

#pragma mark - Public Methods

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    if ([self afterTrim:keyword].length > 0) {
        [self filter];
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)reset {
    self.result = nil;
    [self.tableView reloadData];
    self.tableView.hidden = YES;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJHNetworkInterceptorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[XJHNetworkInterceptorViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier"];
    }
    cell.viewModel = self.result[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.result[indexPath.row].height;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row < self.result.count) {
        !self.callback?:self.callback(self.result[row].model);
    }
}

#pragma mark - Private Methods

- (NSString *)afterTrim:(NSString *)string {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [[string stringByTrimmingCharactersInSet:set] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)filter {
    NSMutableArray<XJHRequestResponseItemViewModel *> *list = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (XJHRequestResponseItemViewModel *vm in self.items) {
        NSRange range = [vm.url rangeOfString:[self afterTrim:self.keyword] options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [list addObject:vm];
        }
    }
    self.result = list.copy;
}

#pragma mark - ViewModel Bind Method

- (void)bindViewModel {
	
}

#pragma mark - Build UI Method

- (void)buildUI {
	self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
}

#pragma mark - Property Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, CGFLOAT_MIN, 0, CGFLOAT_MIN);
        _tableView.separatorColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[XJHNetworkInterceptorViewCell class] forCellReuseIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
