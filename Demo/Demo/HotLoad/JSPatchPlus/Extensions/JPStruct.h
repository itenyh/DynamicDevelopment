//
//  JPStruct.h
//  Demo
//
//  Created by mke Qi on 2018/9/8.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "JPEngine.h"

@interface JPStruct : JPExtension

@property (nonatomic, strong) id value;

+ (JPStruct *)jpStructWith:(CGRect)rect;
- (CGRect)toRect;

@end
