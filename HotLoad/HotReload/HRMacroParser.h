//
//  HRMacroParser.h
//  Demo
//
//  Created by Iten on 2018/9/7.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void (^ParserCallBack)(JSValue *error, NSString *code);

@interface HRMacroParser : NSObject

- (void)parseMacro:(NSString *)input callBack:(ParserCallBack)callBack;

@end
