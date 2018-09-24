//
//  TestViewController.m
//  Demo
//
//  Created by itenyh on 2018/7/25.
//  Copyright © 2018年 Essence. All rights reserved.
//

#define kka @"sadjkfa"
#define dd date

#import <JavaScriptCore/JavaScriptCore.h>
#import "TestViewController.h"
#import "ViewController.h"
#import <objc/runtime.h>
#import "ReferenceCycleView.h"

#import "UIView+Test.h"

typedef void (^ParserCallBack)(JSValue *error, NSString *code);

@interface TestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) ReferenceCycleView *cycleView;

@end

@implementation TestViewController

#pragma - mark ViewDidLoad

- (void)viewDidLoad {

    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.tbView];
//    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    CGRect rec = [self rect1:self.view.frame];
//    NSLog(@"%@", rec);
//    rec.size.height = 123;
////    NSLog(@"%@", rec);
    view.frame = rec;
    
//    CGRect f = [self rect];
//    f.origin.x = 100;
//    f.origin = CGPointMake(43, 3);
//    NSLog(@"%@",  [self rect:CGRectMake(10, 0, 0, 0)]);
//    [self sdfk];π
//    [self rect:CGRectMake(0, 0, 0, 0)];
    
}

- (CGPoint)point {
    return CGPointMake(32, 3);
}

#pragma )(
- (CGRect)rect1:(CGRect)rect {
    rect.size.width = 10;
    rect.size.height = 100;
    return rect;
}

#pragma )(
- (CGRect)rect:(CGRect)rect {
    return rect;
//    return CGRectMake(0, 0, 13, 34);
}

- (int)a:(int)arg arg1:(int)arg1 {
    return arg + arg1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fasfasd"];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 排: %@", indexPath.row, kka];
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

- (ReferenceCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [ReferenceCycleView new];
    }
    return _cycleView;
}

@end
