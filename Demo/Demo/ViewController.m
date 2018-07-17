//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "JPEngine.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *lable;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.lable];
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
}


#pragma - mark LazyLoad

- (UILabel *)lable {
    if (!_lable) {
        _lable = [UILabel new];
        _lable.backgroundColor = [UIColor orangeColor];
        _lable.text = @"流星花园";
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

@end
