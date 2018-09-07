//
//  ReferenceCycleView.h
//  Demo
//
//  Created by Iten on 2018/9/7.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReferenceCycleViewBlock)(NSString *code);

@interface ReferenceCycleView : UIView

@property (nonatomic, copy) ReferenceCycleViewBlock block;

@end
