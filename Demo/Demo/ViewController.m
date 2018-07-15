//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "FileTransferServiceBrowser.h"

@interface ViewController ()

@property (nonatomic, strong) FileTransferServiceBrowser *broswer;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.broswer startBrowsering];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma - mark LazyLoad

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.text = @"你的名字: 新海诚，😁!";
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:13];
        _label.backgroundColor = [UIColor purpleColor];
        _label.textAlignment = 1;
    }
    return _label;
}

- (FileTransferServiceBrowser *)broswer {
    if (!_broswer) {
        _broswer = [FileTransferServiceBrowser new];
    }
    return _broswer;
}


@end
