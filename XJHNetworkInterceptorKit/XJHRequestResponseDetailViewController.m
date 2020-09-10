//
//  XJHRequestResponseDetailViewController.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 2020/9/8.
//
// cocoadogs@163.com

#import "XJHRequestResponseDetailViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "XJHNetFlowDetailViewCell.h"
#import "XJHNetFlowDetailSegment.h"
#import "XJHUrlUtil.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define EM_NAVCONTENT_HEIGHT 44

#define EM_STATUSBAR_HEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height
#define EM_NAVBAR_HEIGHT (EM_STATUSBAR_HEIGHT + EM_NAVCONTENT_HEIGHT)

//根据750*1334分辨率计算size
#define kXJHSizeFrom750(x) ((x)*SCREEN_WIDTH/750)
// 如果横屏显示
#define kXJHSizeFrom750_Landscape(x) (kInterfaceOrientationPortrait ? kXJHSizeFrom750(x) : ((x)*SCREEN_HEIGHT/750))

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

typedef NS_ENUM(NSUInteger, NetFlowSelectState) {
    NetFlowSelectStateForRequest = 0,
    NetFlowSelectStateForResponse
};

@interface XJHRequestResponseDetailViewController ()<UITableViewDelegate, UITableViewDataSource, XJHNetFlowDetailSegmentDelegate>

@property (nonatomic, strong) XJHNetFlowDetailSegment *segmentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;//当前选中的tab

@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSArray *> *> *requestArray;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSArray *> *> *responseArray;

@property (nonatomic, copy) NSArray<NSArray<NSNumber *> *> *requestHeightArray;
@property (nonatomic, copy) NSArray<NSArray<NSNumber *> *> *responseHeightArray;

@property (nonatomic, assign) CGFloat widthMinuslandscape32;

@property (nonatomic, assign) CGFloat landscape28;

@end

@implementation XJHRequestResponseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self bindViewModel];
    [self buildUI];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self calculateCellHeights:NetFlowSelectStateForResponse];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XJHNetFlowDetailSegmentDelegate Methods

- (void)segmentClick:(NSInteger)index {
    _selectedSegmentIndex = index;
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
        default:
            row = 1;
            break;
    }
    return row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 0;
    if (_selectedSegmentIndex == NetFlowSelectStateForRequest) {
        section = 4;
    }else{
        section = 3;
    }
    return section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJHNetFlowDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kXJHNetFlowDetailViewCellIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[XJHNetFlowDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kXJHNetFlowDetailViewCellIdentifier"];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *content;
    if (_selectedSegmentIndex == NetFlowSelectStateForRequest) {
        NSDictionary *itemInfo = _requestArray[section];
        content = itemInfo[@"dataArray"][row];
    } else {
        NSDictionary *itemInfo = _responseArray[section];
        content = itemInfo[@"dataArray"][row];
    }
    if (section == 0) {
        [cell renderUIWithContent:content isFirst:row == 0 isLast:row == 1];
    } else if(section == 1) {
        [cell renderUIWithContent:content isFirst:YES isLast:YES];
    } else if(section == 2) {
        [cell renderUIWithContent:content isFirst:YES isLast:YES];
    } else if (section == 3) {
        [cell renderUIWithContent:content isFirst:YES isLast:YES];
    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSArray<NSNumber *> *> *heights = _selectedSegmentIndex == NetFlowSelectStateForRequest ? _requestHeightArray : _responseHeightArray;
    return heights[indexPath.section][indexPath.row].floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kXJHSizeFrom750_Landscape(100);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title;
    if (_selectedSegmentIndex == NetFlowSelectStateForRequest) {
        NSDictionary *itemInfo = _requestArray[section];
        title = itemInfo[@"sectionTitle"];
    }else{
        NSDictionary *itemInfo = _responseArray[section];
        title = itemInfo[@"sectionTitle"];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kXJHSizeFrom750_Landscape(100))];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor colorWithRed:51/255.0f green:124/255.0f blue:196/255.0f alpha:1];
    tipLabel.font = [UIFont systemFontOfSize:kXJHSizeFrom750_Landscape(32)];
    tipLabel.text = title;
    tipLabel.frame = CGRectMake(kXJHSizeFrom750_Landscape(32), 0, self.view.frame.size.width-kXJHSizeFrom750_Landscape(32), kXJHSizeFrom750_Landscape(100));
    [view addSubview:tipLabel];
    if (@available(iOS 13.0, *)) {
        view.backgroundColor =  [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor systemBackgroundColor];
            } else {
                return [UIColor whiteColor];
            }
        }];
    } else {
        view.backgroundColor = [UIColor whiteColor];
    }
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Copy";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *content;
    if (_selectedSegmentIndex == NetFlowSelectStateForRequest) {
        NSDictionary *itemInfo = _requestArray[section];
        content = itemInfo[@"dataArray"][row];
    }else{
        NSDictionary *itemInfo = _responseArray[section];
        content = itemInfo[@"dataArray"][row];
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = content;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void)calculateCellHeights:(NetFlowSelectState)state {
    NSArray<NSDictionary<NSString *, NSArray *> *> *data = (state == NetFlowSelectStateForResponse ? _responseArray : _requestArray);
    NSMutableArray<NSMutableArray<NSNumber *> *> *list = [[NSMutableArray<NSMutableArray<NSNumber *> *> alloc] initWithCapacity:data.count];
    for (NSDictionary<NSString *, NSArray *> *dict in data) {
        NSArray *array = dict[@"dataArray"];
        NSMutableArray<NSNumber *> *heightList = [[NSMutableArray<NSNumber *> alloc] initWithCapacity:2];
        for (NSString *string in array) {
            CGSize size = calcTextSizeV2(CGSizeMake(self.widthMinuslandscape32, MAXFLOAT), string, 0, [UIFont systemFontOfSize:16]);
            CGFloat result = size.height + self.landscape28;
            [heightList addObject:@(result)];
        }
        [list addObject:heightList];
    }
    state == NetFlowSelectStateForResponse ? (_responseHeightArray = list.copy) : (_requestHeightArray = list.copy);
}

#pragma mark - ViewModel Bind Method

- (void)bindViewModel {
    self.widthMinuslandscape32 = SCREEN_WIDTH-2*kXJHSizeFrom750_Landscape(32);
    self.landscape28 = kXJHSizeFrom750_Landscape(28)*2;
    
    NSString *requestDataSize = [NSString stringWithFormat:@"Size : %@",[XJHUrlUtil formatByte:[self.httpModel.uploadFlow floatValue]]];
    NSString *method = [NSString stringWithFormat:@"Method : %@",self.httpModel.method];
    NSString *linkUrl = self.httpModel.url;
    NSDictionary<NSString *, NSString *> *allHTTPHeaderFields = self.httpModel.request.allHTTPHeaderFields;
    NSMutableString *allHTTPHeaderString = [NSMutableString string];
    for (NSString *key in allHTTPHeaderFields) {
        NSString *value = allHTTPHeaderFields[key];
        [allHTTPHeaderString appendFormat:@"%@ : %@\r\n",key,value];
    }
    if (allHTTPHeaderString.length == 0) {
        allHTTPHeaderString = [NSMutableString stringWithFormat:@"NULL"];
    }
    
    NSString *requestBody = self.httpModel.requestBody;
    if (!requestBody || requestBody.length == 0) {
        requestBody = @"NULL";
    }
    
    _requestArray = @[@{
                          @"sectionTitle":@"Summary",
                          @"dataArray":@[requestDataSize,method]
                          },
                      @{
                          @"sectionTitle":@"Url",
                          @"dataArray":@[linkUrl]
                          },
                      @{
                          @"sectionTitle":@"Header",
                          @"dataArray":@[allHTTPHeaderString]
                          },
                      @{
                          @"sectionTitle":@"Body",
                          @"dataArray":@[requestBody]
                          }
                      ];
    
    NSString *responseDataSize = [NSString stringWithFormat:@"Size : %@",[XJHUrlUtil formatByte:[self.httpModel.downFlow floatValue]]];
    NSString *mineType = [NSString stringWithFormat:@"mineType : %@",self.httpModel.mineType];
    NSMutableString *responseHeaderString = [NSMutableString string];
    for (NSString *key in allHTTPHeaderFields) {
        NSString *value = allHTTPHeaderFields[key];
        [responseHeaderString appendFormat:@"%@ : %@\r\n",key,value];
    }
    if (responseHeaderString.length == 0) {
        responseHeaderString = [NSMutableString stringWithFormat:@"NULL"];
    }
    NSString *responseBody = self.httpModel.responseBody;
    if (!responseBody || requestBody.length == 0) {
        responseBody = @"NULL";
    }
    
    _responseArray = @[@{
                          @"sectionTitle":@"Summary",
                          @"dataArray":@[responseDataSize,mineType]
                          },
                      @{
                          @"sectionTitle":@"Header",
                          @"dataArray":@[responseHeaderString]
                          },
                      @{
                          @"sectionTitle":@"Body",
                          @"dataArray":@[responseBody]
                          }
                      ];
    _selectedSegmentIndex = NetFlowSelectStateForRequest;
    [self calculateCellHeights:NetFlowSelectStateForRequest];
}

#pragma mark - Build UI Method

- (void)buildUI {
	self.title = @"Network Monitor Info";
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor systemBackgroundColor];
            } else {
                return [UIColor colorWithRed:239/255.0f green:240/255.0f blue:244/255.0f alpha:1.0];
            }
        }];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:244/255.0f alpha:1.0];
    }
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
}

#pragma mark - Property Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), SCREEN_WIDTH, self.view.frame.size.height - CGRectGetMaxY(self.segmentView.frame) ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XJHNetFlowDetailViewCell class] forCellReuseIdentifier:@"kXJHNetFlowDetailViewCellIdentifier"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XJHNetFlowDetailSegment *)segmentView {
    if (!_segmentView) {
        _segmentView = [[XJHNetFlowDetailSegment alloc] initWithFrame:CGRectMake(0, EM_NAVBAR_HEIGHT, SCREEN_WIDTH, kXJHSizeFrom750_Landscape(88))];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

@end
