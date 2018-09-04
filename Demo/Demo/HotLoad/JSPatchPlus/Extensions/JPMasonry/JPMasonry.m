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
        //assume param only to be struct or number
        id result;
        if ([jsVal isObject]) {
            NSDictionary *dict = jsVal.toDictionary;
            NSArray *keys = dict.allKeys;
            if (keys.count == 2 && [keys containsObject:@"width"] && [keys containsObject:@"height"]) {
                result = _MASBoxValue(@encode(CGSize), CGSizeMake([dict[@"width"] doubleValue], [dict[@"height"] doubleValue]));
            }
            else if (keys.count == 4 && [keys containsObject:@"top"] && [keys containsObject:@"right"] && [keys containsObject:@"bottom"] && [keys containsObject:@"left"]) {
                result = _MASBoxValue(@encode(UIEdgeInsets), UIEdgeInsetsMake([dict[@"top"] doubleValue], [dict[@"right"] doubleValue], [dict[@"bottom"] doubleValue], [dict[@"left"] doubleValue]));
            }
            
            return [JPExtension formatOCToJS:result];
        }
        else {
            result = jsVal.toNumber;
        }
        return result;
    };
}

+ (NSString *)preProcessSourceCode:(NSString *)sourceCode {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(mas_equalTo|mas_offset)\\((.+)\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray<NSTextCheckingResult *> *matchResults = [regex matchesInString:sourceCode options:0 range:NSMakeRange(0, [sourceCode length])];
    for (NSTextCheckingResult *result in matchResults) {
        NSString *prefix = [sourceCode substringWithRange:[result rangeAtIndex:1]];
        if ([prefix isEqualToString:@"mas_equalTo"]) {
            sourceCode = [regex stringByReplacingMatchesInString:sourceCode options:0 range:NSMakeRange(0, [sourceCode length]) withTemplate:@"equalTo(MMASBoxValue($2))"];
        }
        else if ([prefix isEqualToString:@"mas_offset"]) {
            sourceCode = [regex stringByReplacingMatchesInString:sourceCode options:0 range:NSMakeRange(0, [sourceCode length]) withTemplate:@"valueOffset(MMASBoxValue($2))"];
        }
    }
    
    return sourceCode;
    
}

@end
