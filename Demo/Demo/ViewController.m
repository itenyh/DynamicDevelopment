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

#pragma ()
- (void)viewDidLoad {
    
    [self.view addSubview:self.tbView];
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];

//    self.tbView.frame = @{@"x":@0,@"y":@0,@"width":@100,@"height":@100};
    
    self.view.backgroundColor = [UIColor brownColor];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123321"];
    cell.textLabel.text = [NSString stringWithFormat:@"你爱：%ld", indexPath.row];
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
