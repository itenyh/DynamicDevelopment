//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tbView;

@end

@implementation ViewController

- (void)viewDidLoad {
//    [self.view addSubview:self.tbView];
//    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    self.view.backgroundColor = [UIColor lightTextColor];
    
    [UIView animateWithDuration:10 animations:^{
        self.view.layer.cornerRadius = 2;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123321"];
    cell.textLabel.text = [NSString stringWithFormat:@"你景12：%ld", (long)indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (UITableView *)tbView {
    if(!_tbView) {
        _tbView = [UITableView new];
        _tbView.dataSource = self;
        _tbView.delegate = self;
    }
    return _tbView;
}

@end
