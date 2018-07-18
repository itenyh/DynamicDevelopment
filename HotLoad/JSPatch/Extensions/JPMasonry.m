//
//  JPMasonry.m
//  Demo
//
//  Created by Iten on 2018/7/17.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "JPMasonry.h"

@implementation JPMasonry

+ (void)main:(JSContext *)context {
    
    context[@"MMASBoxValue"] = ^id(JSValue *jsVal) {
        
        NSDictionary *dict = jsVal.toDictionary;
        NSArray *keys = dict.allKeys;
        id result;
        
        if (keys.count == 2 && [keys containsObject:@"width"] && [keys containsObject:@"height"]) {
            result = _MASBoxValue(@encode(CGSize), CGSizeMake([dict[@"width"] doubleValue], [dict[@"height"] doubleValue]));
        }
        else if (keys.count == 4 && [keys containsObject:@"top"] && [keys containsObject:@"right"] && [keys containsObject:@"bottom"] && [keys containsObject:@"left"]) {
            result = _MASBoxValue(@encode(UIEdgeInsets), UIEdgeInsetsMake([dict[@"top"] doubleValue], [dict[@"right"] doubleValue], [dict[@"bottom"] doubleValue], [dict[@"left"] doubleValue]));
        }
        
        return [JPExtension formatOCToJS:result];
        
    };
    
}

+ (NSString *)preProcessSourceCode:(NSString *)sourceCode {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"mas_equalTo\\((.+)\\)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:sourceCode options:0 range:NSMakeRange(0, [sourceCode length]) withTemplate:@"equalTo(MMASBoxValue($1))"];
    return modifiedString;
}

@end
