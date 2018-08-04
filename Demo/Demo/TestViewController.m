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
    
//    NSArray *d = [NSArray arrayWithObjects:[UIView new], @"2", nil];
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@1, @2, nil];
    for (id key in d) {
        NSLog(@"%@", key);
    }

//    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"2", nil];
//    for (id key in set) {
//        [newDict setObject:[NSNumber numberWithInt:1] forKey:[JSValue new]];
//    }
    
//    NSArray *array = [[NSArray alloc] initWithObjects:@"对象abc",@"rongfzh", @"totogo2010",nil];
//    NSSet *set3 = [NSSet setWithArray:array];
//    NSLog(@"%@", set3);
    
//    for (int i = 0;i < set3.count;i++) {
//        NSLog(@"%@", set3[i]);
//    }
    
//    [set3 enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
//
//    }];
    
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//    }];
//
//    [newDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//
//    }];
    
//    for (NSString *str in newDict) {
//        NSLog(@"str %@", str);
//    }
//    
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
