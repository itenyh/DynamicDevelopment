//
//  HRIndicatorView.m
//  Demo
//
//  Created by Iten on 2018/9/4.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "HRIndicatorView.h"

@implementation HRIndicatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.state = HRIndicatorViewUnReady;
    
    self.frame = CGRectMake(0, 200, 30, 30);
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTouch:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapRecognizer];
    
    [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
}

- (void)move:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:sender.view.superview];
    translatedPoint = CGPointMake(sender.view.center.x + translatedPoint.x, sender.view.center.y + translatedPoint.y);
    
    [sender.view setCenter:translatedPoint];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGFloat velocityX = (0.05 * [sender velocityInView:self].x);
        CGFloat velocityY = (0.05 * [sender velocityInView:self].y);
        
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
        
        [self _saveLocation:@[@(finalX), @(finalY)]];
    }
}

- (void)_saveLocation:(NSArray *)location {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *file = [NSString stringWithFormat:@"%@/%@", bundlePath, @"IndicatorLoc.hr"];
    [location writeToFile:file atomically:YES];
}

- (NSArray *)_loadLocation {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *file = [NSString stringWithFormat:@"%@/%@", bundlePath, @"IndicatorLoc.hr"];
    return [[NSArray alloc] initWithContentsOfFile:file];
}

- (void)touch:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HRIndicatorViewDelegateClicked:)]) {
        [self.delegate HRIndicatorViewDelegateClicked:self];
    }
}

- (void)doubleTouch:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HRIndicatorViewDelegateDoubleClicked:)]) {
        [self.delegate HRIndicatorViewDelegateDoubleClicked:self];
    }
}

- (void)setState:(HRIndicatorViewState)state {
    _state = state;
    UIColor *targetColor;
    switch (self.state) {
        case HRIndicatorViewReady:
            targetColor = [UIColor greenColor];
            break;
        case HRIndicatorViewWorking:
            targetColor = [UIColor yellowColor];
            break;
        case HRIndicatorViewError:
            targetColor = [UIColor redColor];
            break;
        case HRIndicatorViewUnReady:
        default:
            targetColor = [UIColor lightGrayColor];
            break;
    }
    [UIView animateWithDuration:1 animations:^{
        self.backgroundColor = targetColor;
    }];
}

@end
