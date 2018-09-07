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
    
//    self.view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.tbView];
//    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
////    fweakify(self)
//    self.cycleView.block = ^(NSString *code) {
////        fstrongify(self)
//        NSLog(@"codie: %@", code);
//        self.nameLabel = nil;
//    };
//
//    self.cycleView.block(@"hahhaa");
    
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
//    view.frame = CGRectMake(0, 0, 100, 100);
//
//    CGRect f = view.frame;
//    f.origin.x = 10;
//    view.frame = f;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"123", @"445"]];
    arr[1] = @"55";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"obj", @"key", nil];
    dic[@"key1"] = @"obj1";
    NSLog(@"%@", dic[@"key1"]);
    
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
