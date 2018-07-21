//
//  JPCGFunction.m
//  Demo
//
//  Created by Iten on 2018/7/16.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "JPCGFunction.h"

@implementation JPCGFunction

+ (void)main:(JSContext *)context {
    
    [JPEngine defineStruct:@{
                             @"name": @"UIEdgeInsets",
                             @"types": @"FFFF",
                             @"keys": @[@"top", @"left", @"bottom", @"right"]
                             }];

    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *file = [NSString stringWithFormat:@"%@/%@", bundlePath, @"constants.hogcs"];
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:content];
    
    __weak JSContext *weakContext = context;
    context[@"CGSizeMake"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSNumber *widthNumber = ((JSValue *)args[0]).toNumber;
        NSNumber *heightNumber = ((JSValue *)args[1]).toNumber;
        CGSize size = CGSizeMake([widthNumber doubleValue], [heightNumber doubleValue]);
        return [JSValue valueWithSize:size inContext:weakContext];
    };
    
    context[@"UIEdgeInsetsMake"] = ^() {
        NSArray *args = [JSContext currentArguments];
        UIEdgeInsets insets = UIEdgeInsetsMake(((JSValue *)args[0]).toNumber.doubleValue, ((JSValue *)args[1]).toNumber.doubleValue, ((JSValue *)args[2]).toNumber.doubleValue, ((JSValue *)args[3]).toNumber.doubleValue);
        return [JPExtension getDictOfStruct:&insets structDefine:[JPExtension registeredStruct][@"UIEdgeInsets"]];
    };
    
}


@end
