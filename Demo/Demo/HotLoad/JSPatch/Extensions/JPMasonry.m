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
            result = _MASBoxValue("{CGSize=dd}", CGSizeMake([dict[@"width"] doubleValue], [dict[@"height"] doubleValue]));
        }
        
        return [JPExtension formatOCToJS:result];
        
    };
    
}

+ (NSString *)preProcessSourceCode:(NSString *)sourceCode {

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"mas_equalTo\\((.+)\\)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:sourceCode options:0 range:NSMakeRange(0, [sourceCode length]) withTemplate:@"equalTo(MMASBoxValue($1))"];
    return modifiedString;
    
//    NSString *string = @"make.size.mas_equalTo(CGSizeMake(10, 10));";
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"mas_equalTo\\((.+)\\)" options:NSRegularExpressionCaseInsensitive error:&error];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"equalTo(MMASBoxValue($1))"];
//    NSLog(@"%@", modifiedString);
//    return @"";
}

@end
