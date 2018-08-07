//
//  TestViewController.m
//  Demo
//
//  Created by itenyh on 2018/7/25.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "TestViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TestViewController ()

@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) UILabel *slabel;
    
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor brownColor];
//    [self.view addSubview:self.slabel];
//    [self.slabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//    }];
    
    NSArray *d = [NSArray arrayWithObjects:[UIView new], @"2", nil];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@1, @2, @3, @4, @5, @6, @7, @8, nil];
    for (id key in d) {
        NSLog(@"%@", key);
    }
    
//    NSArray *arr = [NSArray arrayWithObjects:<#(nonnull id), ...#>, nil];

//    CGRect rect = [self test:CGRectMake(1, 1, 1, 1)];
//    NSLog(@"resct: %@", rect);
    
}

- (CGRect)test:(CGRect)rect {
    return rect;
}

- (UILabel *)slabel {
    if (!_slabel) {
        _slabel = [UILabel new];
        _slabel.text = @"杨汉";
//        _slabel.backgroundColor = [UIColor blackColor];
//        _slabel.textColor = [UIColor blueColor];
    }
    return _slabel;
}

@end
