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

    [context evaluateScript:@"global.NSTextAlignmentLeft = 0; global.NSTextAlignmentCenter = 1;"];
    
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
    
    context[@"NSLog"] = ^() {
        NSArray *arguments = [JSContext currentArguments];
        NSString *logContent = @"";
        if (arguments.count == 1) { logContent = arguments[0]; }
        else if (arguments.count == 2) { logContent = [NSString stringWithFormat:arguments[0], arguments[1]]; }
        else if (arguments.count == 3) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2]]; }
        else if (arguments.count == 4) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2], arguments[3]]; }
        else if (arguments.count == 5) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]]; }
        else if (arguments.count == 6) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]]; }
        else if (arguments.count == 7) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]]; }
        else if (arguments.count == 8) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]]; }
        else if (arguments.count == 9) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]]; }
        else if (arguments.count == 10) { logContent = [NSString stringWithFormat:arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]]; }
        else {
            logContent = [NSString stringWithFormat:@"%@", arguments];
        }
        NSLog(@"%@", logContent);
    };
    
}

@end
