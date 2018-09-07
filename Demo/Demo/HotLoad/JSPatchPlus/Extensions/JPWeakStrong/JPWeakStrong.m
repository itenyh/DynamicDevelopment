//
//  JPWeakStrong.m
//  Demo
//
//  Created by Iten on 2018/9/7.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "JPWeakStrong.h"

@implementation JPWeakStrong

+ (NSString *)preProcessSourceCode:(NSString *)sourceCode {
    NSMutableString *macros = [NSMutableString string];
    [macros appendString:@"#define fweakify(VAR) id weakVAR = weakify(VAR);\n"];
    [macros appendString:@"#define fstrongify(VAR) id VAR = strongify(weakVAR);\n"];
    return [[macros copy] stringByAppendingFormat:@"\n%@", sourceCode];
}


@end
