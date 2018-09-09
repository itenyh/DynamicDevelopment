//
//  TestViewController.m
//  Demo
//
//  Created by itenyh on 2018/7/25.
//  Copyright © 2018年 Essence. All rights reserved.
//

#define kk [NSDate dd]
#define dd date

#import <JavaScriptCore/JavaScriptCore.h>
#import "TestViewController.h"
#import "ViewController.h"
#import <objc/runtime.h>
#import "ReferenceCycleView.h"

typedef void (^ParserCallBack)(JSValue *error, NSString *code);

@interface TestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) ReferenceCycleView *cycleView;

@end

@implementation TestViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
//    [self.view addSubview:self.tbView];
//    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(a:arg1:)];
//    NSInvocation *invko = [NSInvocation invocationWithMethodSignature:sig];
//    [invko setTarget:self];
//    [invko setSelector:@selector(a:arg1:)];
//    double arg = 4.0f;
//    long arg1 = 5;
//    [invko setArgument:&arg atIndex:2];
//    [invko setArgument:&arg1 atIndex:3];
//    [invko invoke];
//    long i;
//    [invko getReturnValue:&i];
//    NSLog(@"%ld", i);
//
//    [self a:3 arg1:4];
    
//    [self rect];
    
    CGRect f = [self rect];
    f.origin.x = 100;
    NSLog(@"%f", f.origin.x);
    
}

- (CGPoint)point {
    return CGPointMake(32, 3);
}

- (CGRect)rect {
    return CGRectMake(1, 2, 3, 4);
}

- (int)a:(int)arg arg1:(int)arg1 {
    return arg + arg1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fasfasd"];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 排: %@", indexPath.row, kk];
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
