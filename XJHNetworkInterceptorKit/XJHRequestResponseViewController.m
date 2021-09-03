//
//  XJHRequestResponseViewController.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//
// cocoadogs@163.com

#import "XJHRequestResponseViewController.h"
#import "XJHRequestResponseDetailViewController.h"
#import "XJHRequestResponseSearchViewController.h"
#import "XJHNetworkInterceptorViewCell.h"
#import "XJHRequestResponseViewModel.h"
#import "XJHNetFlowManager.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

#define EM_NAVCONTENT_HEIGHT 44

#define EM_STATUSBAR_HEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height
#define EM_NAVBAR_HEIGHT (EM_STATUSBAR_HEIGHT + EM_NAVCONTENT_HEIGHT)

@interface XJHRequestResponseViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) XJHRequestResponseViewModel *viewModel;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL searching;

@property (nonatomic, strong) UIBarButtonItem *clearItem;

@property (nonatomic, strong) UIBarButtonItem *switchItem;

@property (nonatomic, strong) XJHRequestResponseSearchViewController *searchVC;

@end

@implementation XJHRequestResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self buildUI];
	[self bindViewModel];
    [self addObserver];
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

#pragma mark - Private Methods

- (void)dismissSearchVC {
    [self.searchVC.view removeFromSuperview];
    [self.searchVC reset];
    [self.searchVC removeFromParentViewController];
    self.searching = NO;
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
}

- (void)addObserver {
    @weakify(self)
    [[RACObserve(self, searching) distinctUntilChanged] subscribeNext:^(NSNumber *number) {
        @strongify(self)
        self.clearItem.enabled = !number.boolValue;
    }];
}

- (void)showDetail:(XJHNetFlowHttpModel *)model {
    XJHRequestResponseDetailViewController *detailVC = [[XJHRequestResponseDetailViewController alloc] init];
    detailVC.httpModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searching = YES;
    [self addChildViewController:self.searchVC];
    [self.view addSubview:self.searchVC.view];
    [self.view bringSubviewToFront:self.searchVC.view];
    CGFloat height = CGRectGetMaxY(self.searchBar.frame);
    self.searchVC.view.frame = CGRectMake(0, height, SCREEN_WIDTH, self.view.frame.size.height - height);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self dismissSearchVC];
        [self.searchBar resignFirstResponder];
    } else {
        self.searchVC.keyword = searchText;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissSearchVC];
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJHNetworkInterceptorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[XJHNetworkInterceptorViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier"];
    }
    cell.viewModel = self.viewModel.items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.items[indexPath.row].height;
}

#pragma mark - ViewModel Bind Method

- (void)bindViewModel {
	@weakify(self)
    self.searchVC.callback = ^(XJHNetFlowHttpModel *model) {
        @strongify(self)
        [self showDetail:model];
    };
    [self.viewModel.clearCommand.executionSignals subscribeNext:^(RACSignal *signal) {
        [signal subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.tableView reloadData];
        }];
    }];
    [self.viewModel.selectionSignal subscribeNext:^(XJHNetFlowHttpModel *model) {
        @strongify(self)
        [self showDetail:model];
    }];
    self.clearItem.rac_command = self.viewModel.clearCommand;
}

#pragma mark - Build UI Method

- (void)buildUI {
	self.navigationItem.title = @"Request & Response";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.navigationItem.rightBarButtonItems = @[self.clearItem, self.switchItem];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    self.searchBar.frame = CGRectMake(0, EM_NAVBAR_HEIGHT, SCREEN_WIDTH, 44);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, self.view.frame.size.height - CGRectGetMaxY(self.searchBar.frame));
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count <= 1) {
        self.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:({
                UIBarButtonSystemItem style = UIBarButtonSystemItemStop;
                if (@available(iOS 13.0, *)) {
                    style = UIBarButtonSystemItemClose;
                }
                style;
            }) target:nil action:nil];
            @weakify(self)
            item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    @strongify(self)
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }];
            item;
        });
    }
}

#pragma mark - Property Methods

- (XJHRequestResponseViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XJHRequestResponseViewModel alloc] init];
    }
    _viewModel.filters = self.filters;
    return _viewModel;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = @"请输入API";
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[XJHNetworkInterceptorViewCell class] forCellReuseIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, CGFLOAT_MIN, 0, CGFLOAT_MIN);
        _tableView.separatorColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XJHRequestResponseSearchViewController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[XJHRequestResponseSearchViewController alloc] init];
    }
    _searchVC.items = self.viewModel.items;
    return _searchVC;
}

- (UIBarButtonItem *)clearItem {
    if (!_clearItem) {
        _clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:nil action:nil];
    }
    return _clearItem;
}

- (UIBarButtonItem *)switchItem {
    if (!_switchItem) {
        _switchItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UISwitch *onBtn = [[UISwitch alloc] init];
            [[onBtn rac_newOnChannel] subscribeNext:^(NSNumber * _Nullable x) {
                [[XJHNetFlowManager sharedInstance] canInterceptNetFlow:x.boolValue];
            }];
            onBtn.on = [XJHNetFlowManager sharedInstance].canIntercept;
            onBtn;
        })];
    }
    return _switchItem;
}


@end
