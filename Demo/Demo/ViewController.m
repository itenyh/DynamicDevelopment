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
  
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
}

- (CGRect)test2 {
    return CGRectMake(1, 1, 1, 1);
}

- (CGRect)test1 {
    UIView *v = [UIView new];
    v.frame = CGRectMake(0, 1, 10, 10);
    return v.frame;
}

#pragma - mark LazyLoad

- (UILabel *)lable {
    if (!_lable) {
        _lable = [UILabel new];
        _lable.backgroundColor = [UIColor orangeColor];
        _lable.text = @"流星";
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

@end
