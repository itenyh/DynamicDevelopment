//
//  JPStruct.m
//  Demo
//
//  Created by mke Qi on 2018/9/8.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "JPStruct.h"

@implementation JPStruct

+ (id)formatOCToJS:(id)obj {
    if ([obj isKindOfClass:NSDictionary.class]) {
        JPStruct *jpStruct = [JPStruct new];
        jpStruct.value = obj;
        return [JPExtension formatOCToJS:jpStruct];
    }
    else {
        JPBoxing *box = [JPBoxing new];
        [box setValue:obj forKey:@"obj"];
        box.typeString = @"saf";
        return [JPExtension formatOCToJS:box];
    }
}

+ (JPStruct *)jpStructWith:(CGRect)rect {
    JPStruct *result = [JPStruct new];
    result.value = [NSMutableDictionary dictionaryWithDictionary: @{@"origin":@{@"x":@(rect.origin.x), @"y":@(rect.origin.y)}, @"size":@{@"width":@(rect.size.width), @"height":@(rect.size.height)}}];
    return result;
}

@end
