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

@interface TestViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITableView *tbView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tbView];
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    
    ViewController *vc = [ViewController new];
    int a = 4;
    [vc bb:a];
    
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
//    NSLog(@"%d", 5 + section);
    return 5 + section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = @"123";
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
