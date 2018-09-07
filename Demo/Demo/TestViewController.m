//
//  TestViewController.m
//  Demo
//
//  Created by itenyh on 2018/7/25.
//  Copyright © 2018年 Essence. All rights reserved.
//

#define kk "as\"df"

#import "TestViewController.h"
#import "ViewController.h"
#import <objc/runtime.h>

@interface TestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITableView *tbView;


@end

@implementation TestViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *file = [NSString stringWithFormat:@"%@/%@", bundlePath, @"user_macro.hr"];
//    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
//    NSArray<NSString *> *macroPieces = [content componentsSeparatedByString:@"#define"];
//    NSLog(@"macroPieces: %@", macroPieces);
//    for (NSString *macroPiece in macroPieces) {
//
//    }
    
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tbView];
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fasfasd"];
    NSDate *date = [NSDate date];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 排: %@", indexPath.row, date];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableView *)tbView {
    if (!_tbView) {
        _tbView = [UITableView new];
        _tbView.dataSource = self;
        _tbView.delegate = self;
    }
    return _tbView;
}

@end
