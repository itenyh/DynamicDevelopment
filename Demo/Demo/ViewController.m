//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma hotdev exclusive

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

int funcA(NSObject *obj, float num) {
    
    NSLog(@"object: %@, num: %f", obj, num);
    return 13;
    
}

#pragma - mark LazyLoad


@end
