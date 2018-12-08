//
//  TestViewController.m
//  Demo
//
//  Created by itenyh on 2018/12/8.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.view.backgroundColor = [UIColor redColor];
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.text = @"Hello World";
        _label.font = [UIFont systemFontOfSize:40];
    }
    return _label;
}

@end
