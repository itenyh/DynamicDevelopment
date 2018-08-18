//
//  TestViewController.m
//  Demo
//
//  Created by itenyh on 2018/7/25.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "TestViewController.h"
#import "ViewController.h"
#import <objc/runtime.h>

@interface TestViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, assign) NSInteger b;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tbView];
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    self.b = 2;
    NSLog(@"%ld", (long)self.b);
//    JP_FWD_ARG_CASE('c', char)
//    JP_FWD_ARG_CASE('C', unsigned char)
//    JP_FWD_ARG_CASE('s', short)
//    JP_FWD_ARG_CASE('S', unsigned short)
//    JP_FWD_ARG_CASE('i', int)
//    JP_FWD_ARG_CASE('I', unsigned int)
//    JP_FWD_ARG_CASE('l', long)
//    JP_FWD_ARG_CASE('L', unsigned long)
//    JP_FWD_ARG_CASE('q', long long)
//    JP_FWD_ARG_CASE('Q', unsigned long long)
//    JP_FWD_ARG_CASE('f', float)
//    JP_FWD_ARG_CASE('d', double)
    
//    JP_FWD_ARG_CASE('B', BOOL)
    
//    self.view.backgroundColor = [UIColor grayColor];
//
//    [self.view addSubview:self.nameLabel];
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//    }];

//    NSArray *a = @[@"a", @"b"];
//    [a enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@", a[idx]);
//    }];
    
//    [self aa:1];
    
//    NSString *a = [NSString stringWithFormat:@"%c", 'c'];
//    NSLog(@"%@", a);
////
//    ViewController *vc = [ViewController new];
//    int a = 4;
//    [vc aa:a];
    
//    [self tt:^(NSString *param) {
//        NSLog(@"%@", param);
//    }];
    
}

//- (void)aa:(int)m {
////    NSNumber *numObj = [NSNumber numberWithInt:1];
////    NSArray *a = @[@"a", @"b"];
////    NSLog(@"====> %@", a[numObj]);
//    NSLog(@"aa:%d", m);
//}

//- (void)tt:(void (^)(NSString *))blk {
//    blk(@"cao!");
//}

//- (UILabel *)nameLabel {
//    if (!_nameLabel) {
//        _nameLabel = [UILabel new];
//        _nameLabel.text = @"My Name is YangHan";
//    }
//    return _nameLabel;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5 + section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = @"1234";
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = @"789";
        return cell;
    }
    return nil;
}

-(UITableView *)tbView {
    if (!_tbView) {
        _tbView = [UITableView new];
        _tbView.dataSource = self;
        _tbView.delegate = self;
    }
    return _tbView;
}

@end
