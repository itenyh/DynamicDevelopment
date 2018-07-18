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
  
//      NSLog(self.view.frame.size);
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:self.lable];
//    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.mas_equalTo(self.view.frame.size);
//    }];

//    UIView *a = [UIView new];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:a forKey:@"aaa"];
//    NSLog(@"%@", dic);
//    CLLocation *loc = CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>);
//    NSString *s = [NSString stringWithFormat:@"%@", self.lable.frame.size.width];
//    NSLog(@"result: %@", s);
//    NSLog(@"%@ #### %d %f %s", self, 13, 324.2, "132");
 
//    JSContext *context = [JSContext new];
//    context[@"test"] = ^() {
////        return 12;
//        return [JSValue valueWithInt32:12 inContext:context];
//    };
//    [context evaluateScript:@"function a() {\
//     return test();\
//    }"];
//    JSValue *value = [[context objectForKeyedSubscript:@"a"] callWithArguments:nil];
//    NSLog(@"value: %@ valueClass: %@", value, [value.toObject class]);
 
//    CGRect rect = [self test1:self.view.frame];
//    NSLog(@"====== %@", rect);
}

- (CGRect)test1:(CGRect)rect {
    NSLog(@"rect: %f", rect.size.width);
    return rect;
}

#pragma - mark LazyLoad

//- (UILabel *)lable {
//    if (!_lable) {
//        _lable = [UILabel new];
//        _lable.backgroundColor = [UIColor orangeColor];
//        _lable.text = @"流星";
//        _lable.textAlignment = NSTextAlignmentCenter;
//    }
//    return _lable;
//}

@end
