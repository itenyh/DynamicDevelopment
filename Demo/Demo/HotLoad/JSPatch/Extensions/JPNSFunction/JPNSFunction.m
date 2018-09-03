//
//  JPNSFounction.m
//  Demo
//
//  Created by Iten on 2018/7/18.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "JPNSFunction.h"

@implementation JPNSFunction

+ (void)main:(JSContext *)context {
   
    __weak JSContext *weakContext = context;
    
    [context evaluateScript:@"defineCFunction(\"NSStringFromClass\", \"NSString *, Class\")"];
    
    context[@"address"] = ^(JSValue *value) {
        JPBoxing *box = [JPBoxing new];
        int temp = [value toInt32];
        box.pointer = &temp;
        return box;
    };
    
    context[@"NSMakeRange"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSNumber *locNumber = ((JSValue *)args[0]).toNumber;
        NSNumber *lenNumber = ((JSValue *)args[1]).toNumber;
        NSRange range = NSMakeRange([locNumber integerValue], [lenNumber integerValue]);
        return [JSValue valueWithRange:range inContext:weakContext];
    };
    
    context[@"_OC_equal"] = ^(JSValue *arg1, JSValue *arg2) {
        return [JPExtension formatJSToOC:arg1] == [JPExtension formatJSToOC:arg2];
    };
    
    context[@"NSLog"] = ^() {
        NSString *logContent = [[weakContext objectForKeyedSubscript:@"NSStringFormat"] callWithArguments:[JSContext currentArguments]].toString;
        NSLog(@"%@", logContent);
    };
    
    context[@"NSStringFormat"] = ^() {
        NSMutableString *result = [NSMutableString string];
        NSArray *arguments = [JSContext currentArguments];
        NSMutableArray *formators = [NSMutableArray array];
        NSString *formatString = ((JSValue *)arguments[0]).toString;
        static NSString *uniqueString = @"!{||(&^RTF45";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"%(@|d|ld|f|s)" options:NSRegularExpressionCaseInsensitive error:nil];
        [regex enumerateMatchesInString:formatString options:0 range:NSMakeRange(0, formatString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSString *formator = [formatString substringWithRange:NSMakeRange(result.range.location + 1, result.range.length - 1)];
            [formators addObject:formator];
        }];
        formatString = [formatString stringByReplacingOccurrencesOfString:@"#" withString:uniqueString];
        formatString = [regex stringByReplacingMatchesInString:formatString options:0 range:NSMakeRange(0, formatString.length) withTemplate:@"%@#"];
        NSArray *formatPieces = [formatString componentsSeparatedByString:@"#"];
        for (int i = 0; i < formatPieces.count - 1; i++) {
            NSString *piece = formatPieces[i];
            JSValue *arg = arguments[i + 1];
            NSString *formator = formators[i];
            if ([formator isEqualToString:@"@"]) {
                arg = [JPExtension formatJSToOC:arg];
            }
            [result appendString:[NSString stringWithFormat:piece, arg]];
        }
        [result appendString:formatPieces[formatPieces.count - 1]];
        [result replaceOccurrencesOfString:uniqueString withString:@"#" options:0 range:NSMakeRange(0, result.length)];
        return result;
    };
    
}

+ (NSString *)preProcessSourceCode:(NSString *)sourceCode {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[NSString stringWithFormat:(.+)\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    sourceCode = [regex stringByReplacingMatchesInString:sourceCode options:0 range:NSMakeRange(0, [sourceCode length]) withTemplate:@"NSStringFormat($1)"];
    return sourceCode;
}

@end
