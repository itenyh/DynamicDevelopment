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
  
    self.view.frame;
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:self.lable];
//    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(100, 150));
//    }];

//    UIView *a = [UIView new];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:a forKey:@"aaa"];
//    NSLog(@"%@", dic);
//    CLLocation *loc = CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>);
//    NSString *s = [NSString stringWithFormat:@"%@", self.lable.frame.size.width];
//    NSLog(@"result: %@", s);
//    NSLog(@"%@ #### %d %f %s", self, 13, 324.2, "132");
    
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
