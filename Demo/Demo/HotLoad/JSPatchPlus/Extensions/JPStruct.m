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
    id origin = [JPStruct mut:@{@"x":@(rect.origin.x), @"y":@(rect.origin.y)}];
    id size = [JPStruct mut:@{@"width":@(rect.size.width), @"height":@(rect.size.height)}];
    result.value = [JPStruct mut: @{@"origin":origin, @"size":size}];
    return result;
}

- (CGRect)toRect {
    CGRect rect;
    NSMutableDictionary *value = self.value;
    NSMutableDictionary *origin = value[@"origin"];
    NSMutableDictionary *size = value[@"size"];
    rect.origin.x = [origin[@"x"] floatValue];
    rect.origin.y = [origin[@"y"] floatValue];
    rect.size.width = [size[@"width"] floatValue];
    rect.size.height = [size[@"height"] floatValue];
    return rect;
}

+ (NSMutableDictionary *)mut:(NSDictionary *)dict {
    return [NSMutableDictionary dictionaryWithDictionary:dict];
}


@end
