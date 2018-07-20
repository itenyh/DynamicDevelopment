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
    [self test:^(NSString *param) {
        
    } haha:@"sdfs"];
//    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
}

//- (UILabel *)lable {
//    if (!_lable) {
//        _lable = [UILabel new];
//        _lable.backgroundColor = [UIColor orangeColor];
//        _lable.text = @"流星";
//        _lable.textAlignment = NSTextAlignmentCenter;
//    }
//    return _lable;
//}localMethods

#pragma )(
- (void)test:(void (^)(NSString *param))blk haha:(NSString *)h {
    
}

@end
