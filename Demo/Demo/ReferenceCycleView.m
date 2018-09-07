//
//  ReferenceCycleView.m
//  Demo
//
//  Created by Iten on 2018/9/7.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ReferenceCycleView.h"

@interface ReferenceCycleView ()


@end

@implementation ReferenceCycleView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ReferenceCycleView Dealloc");
}

@end
