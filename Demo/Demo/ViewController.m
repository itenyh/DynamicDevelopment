//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "FileTransferServiceBrowser.h"
#import "NiceLabel.h"

@interface ViewController ()

@property (nonatomic, strong) FileTransferServiceBrowser *broswer;
@property (nonatomic, strong) NiceLabel *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

#pragma hotdev exclusive
- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.label];
//    [self.view addSubview:self.imageView];
    
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(10, 10, 10, 10));
//    }];
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.with.equalTo(CGSizeMake(100, 200).width);
//        make.size.height.equalTo(CGSizeMake(100, 200).height);
//    }];
//    NSLog(@"=====> %@", @"1");
//    [NSString stringWithFormat:@"%@", @"123"];
//    NSLog(CGSizeMake(100, 200)|_dot_|width);
    [self test];
//    NSLog(CGSizeMake(100, 200)|_dot_|width);
//    NSLog(@"%@", @"123");
}

#pragma - mark LazyLoad

- (CGSize)test {
    return CGSizeMake(100, 100);
}

- (NiceLabel *)label {
    if (!_label) {
        _label = [NiceLabel new];
        _label.text = @"你的名字: 新海，😁131231";
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor purpleColor];
        _label.textAlignment = 1;
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (FileTransferServiceBrowser *)broswer {
    if (!_broswer) {
        _broswer = [FileTransferServiceBrowser new];
    }
    return _broswer;
}


@end
