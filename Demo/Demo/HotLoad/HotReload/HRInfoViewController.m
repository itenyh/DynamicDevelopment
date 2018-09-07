//
//  HRInfoViewController.m
//  Demo
//
//  Created by Iten on 2018/9/4.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "HRInfoViewController.h"

@interface HRInfoViewController ()

@property (nonatomic, strong) NSMutableString *info;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation HRInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:60],
                                [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat offsetY = self.textView.contentSize.height - self.view.frame.size.height;
    offsetY = offsetY < 0 ? 0 : offsetY;
    [self.textView setContentOffset:CGPointMake(0, offsetY)];
}

- (void)clear {
    [self.info setString:@"【 HotLoad 】 Log Info:\n\n"];
    self.textView.text = [self.info copy];
}

- (void)appendInfo:(NSString *)content {
    [self.info appendString:content];
    [self.info appendString:@"\n"];
    self.textView.text = [self.info copy];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
    }
    return _textView;
}

- (NSMutableString *)info {
    if (!_info) {
        _info = [NSMutableString string];
    }
    return _info;
}

@end
