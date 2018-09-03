//
//  TestViewController.m
//  Demo
//
//  Created by itenyh on 2018/7/25.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "TestViewController.h"
#import "ViewController.h"
#import <objc/runtime.h>

@interface TestViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITableView *tbView;

@property (nonatomic, strong) UIView *stateView;

@property (nonatomic, assign) CGFloat firstX;
@property (nonatomic, assign) CGFloat firstY;

@end

@implementation TestViewController

- (void)viewDidLoad {

    [self test];
    
    [self test];
    
}

- (void)test {
    static int a = 0;
    {
        a++;
        static int a = 2;
        NSLog(@"inner %d", a++);
    }
    NSLog(@"outer %d", a);
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.stateView];
    
    self.stateView.frame = CGRectMake(0, 0, 40, 40);
    self.stateView.layer.cornerRadius = self.stateView.frame.size.width / 2;
    self.stateView.layer.borderWidth = 2;
    self.stateView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.stateView addGestureRecognizer:panRecognizer];
    
}

- (void)move:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:sender.view.superview];
    translatedPoint = CGPointMake(sender.view.center.x + translatedPoint.x, sender.view.center.y + translatedPoint.y);
    
    [sender.view setCenter:translatedPoint];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
    
        CGFloat velocityX = (0.05 * [sender velocityInView:self.view].x);
        CGFloat velocityY = (0.05 * [sender velocityInView:self.view].y);
        
        CGFloat finalX = translatedPoint.x + velocityX;
        CGFloat finalY = translatedPoint.y + velocityY;
        
        if ((finalX - sender.view.frame.size.width / 2) < 0) {
            finalX = sender.view.frame.size.width / 2;
        }
        else if ((finalX + sender.view.frame.size.width / 2) > sender.view.superview.frame.size.width) {
            finalX = sender.view.superview.frame.size.width - sender.view.frame.size.width / 2;
        }
        
        if ((finalY - sender.view.frame.size.height / 2) < 0) {
            finalY = sender.view.frame.size.height / 2;
        }
        else if ((finalY + sender.view.frame.size.height / 2) > sender.view.superview.frame.size.height) {
            finalY = sender.view.superview.frame.size.height - sender.view.frame.size.height / 2;
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
    }
}

- (UIView *)stateView {
    if (!_stateView) {
        _stateView = [UIView new];
        _stateView.backgroundColor = [UIColor redColor];
    }
    return _stateView;
}

@end
