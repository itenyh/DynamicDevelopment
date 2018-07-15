//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "FileTransferServiceBrowser.h"

@interface ViewController ()

@property (nonatomic, strong) FileTransferServiceBrowser *broswer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.broswer startBrowsering];
}

#pragma - mark LazyLoad

- (FileTransferServiceBrowser *)broswer {
    if (!_broswer) {
        _broswer = [FileTransferServiceBrowser new];
    }
    return _broswer;
}


@end
