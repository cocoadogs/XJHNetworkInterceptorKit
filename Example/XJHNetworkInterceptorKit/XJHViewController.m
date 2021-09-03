//
//  XJHViewController.m
//  XJHNetworkInterceptorKit
//
//  Created by cocoadogs on 09/07/2020.
//  Copyright (c) 2020 cocoadogs. All rights reserved.
//

#import "XJHViewController.h"
#import <XJHNetworkInterceptorKit/XJHRequestResponseViewController.h>

@interface XJHViewController ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation XJHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Home";
    [self.view addSubview:self.btn];
    self.btn.frame = CGRectMake(0, 0, 100, 44);
    self.btn.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showVC {
    XJHRequestResponseViewController *vc = [[XJHRequestResponseViewController alloc] init];
    vc.filters = @[@""];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:^{
        
    }];
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setTitle:@"拦截" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular]];
        [_btn setBackgroundColor:[UIColor blueColor]];
        [_btn addTarget:self action:@selector(showVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end
