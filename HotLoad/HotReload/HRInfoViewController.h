//
//  HRInfoViewController.h
//  Demo
//
//  Created by Iten on 2018/9/4.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRInfoViewController : UIViewController

@property (nonatomic, assign) BOOL isPresented;

- (void)appendInfo:(NSString *)content;
- (void)clear;

@end
