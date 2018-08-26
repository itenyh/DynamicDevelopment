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

@end

@implementation TestViewController

#pragma ()
- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.view addSubview:self.tbView];
//    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];

    int c = 1;
    id a = @(1);
    int *d;
    [self get:d];
    NSLog(@"%d", c);

//    [self getObj:@"123"];
    
}

- (void)get:(int *)a {
    *a = 5;
}

- (void)getObj:(NSString *)a {
    
}

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
        cell.textLabel.text = @"789apo";
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
