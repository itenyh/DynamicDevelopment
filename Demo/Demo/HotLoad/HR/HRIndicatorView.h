//
//  HRIndicatorView.h
//  Demo
//
//  Created by Iten on 2018/9/4.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRIndicatorView;
@protocol HRIndicatorViewDelegate <NSObject>

- (void)HRIndicatorViewDelegateClicked:(HRIndicatorView *)view;

@end

typedef NS_ENUM(NSInteger, HRIndicatorViewState) {
    HRIndicatorViewUnReady = 0,
    HRIndicatorViewReady,
    HRIndicatorViewWorking,
    HRIndicatorViewError,
};

@interface HRIndicatorView : UIView

@property (nonatomic, assign) HRIndicatorViewState state;
@property (nonatomic, weak) id<HRIndicatorViewDelegate> delegate;

@end
