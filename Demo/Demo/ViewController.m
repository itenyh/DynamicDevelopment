//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "JPEngine.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@property (nonatomic, strong) UILabel *lable;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [self.view addSubview:self.lable];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(23);
    }];
    
    [super updateViewConstraints];
}

- (UILabel *)lable {
    if (!_lable) {
        _lable = [UILabel new];
        _lable.backgroundColor = [UIColor orangeColor];
        _lable.text = @"流afa";
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}


@end
