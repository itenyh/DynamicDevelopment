//
//  HRMacroParser.m
//  Demo
//
//  Created by Iten on 2018/9/7.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "HRMacroParser.h"

@interface HRMacroParser ()

@property (nonatomic, strong) JSContext *JSContext;
@property (nonatomic, strong) JSValue *parser;

@end

@implementation HRMacroParser

#pragma - mark

- (void)parseMacro:(NSString *)input callBack:(ParserCallBack)callBack {
    [self.parser callWithArguments:@[input, callBack]];
}

#pragma - mark lazy load

- (JSContext *)JSContext {
    if (!_JSContext) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *file = [NSString stringWithFormat:@"%@/%@", bundlePath, @"macro_parser_hr.js"];
        NSString *scriptString = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        _JSContext = [JSContext new];
        [_JSContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
                        NSString *stacktrace = [exception objectForKeyedSubscript:@"stack"].toString;
                        NSNumber *lineNumber = [exception objectForKeyedSubscript:@"line"].toNumber;
                        NSLog(@"ParseMacro Exception: %@ \n lineNumber: %@ \n exception: %@", stacktrace, lineNumber, exception);
            NSLog(@"error should not come here");
        }];
        [_JSContext evaluateScript:scriptString];
    }
    return _JSContext;
}

- (JSValue *)parser {
    if (!_parser) {
        _parser = [[self.JSContext objectForKeyedSubscript:@"global"] objectForKeyedSubscript:@"parse"];
    }
    return _parser;
}

@end
