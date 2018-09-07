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
    
    context[@"HRMASBoxValue"] = ^id(JSValue *jsVal) {
        //assume param only to be struct or number
        id result;
        if ([jsVal isObject]) {
            NSDictionary *dict = jsVal.toDictionary;
            NSArray *keys = dict.allKeys;
            if (keys.count == 2 && [keys containsObject:@"width"] && [keys containsObject:@"height"]) {
                result = HRMASBoxValue(@encode(CGSize), CGSizeMake([dict[@"width"] doubleValue], [dict[@"height"] doubleValue]));
            }
            else if (keys.count == 4 && [keys containsObject:@"top"] && [keys containsObject:@"left"] && [keys containsObject:@"bottom"] && [keys containsObject:@"right"]) {
                result = HRMASBoxValue(@encode(UIEdgeInsets), UIEdgeInsetsMake([dict[@"top"] doubleValue], [dict[@"left"] doubleValue], [dict[@"bottom"] doubleValue], [dict[@"right"] doubleValue]));
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
    NSMutableString *macros = [NSMutableString string];
    [macros appendString:@"#define mas_equalTo(__VA_ARGS__)                 equalTo(HRMASBoxValue((__VA_ARGS__)))\n"];
    [macros appendString:@"#define mas_greaterThanOrEqualTo(__VA_ARGS__)    equalTo(HRMASBoxValue((__VA_ARGS__)))\n"];
    [macros appendString:@"#define mas_lessThanOrEqualTo(__VA_ARGS__)       equalTo(HRMASBoxValue((__VA_ARGS__)))\n"];
    [macros appendString:@"#define mas_offset(__VA_ARGS__)                  equalTo(HRMASBoxValue((__VA_ARGS__)))\n"];
    return [[macros copy] stringByAppendingFormat:@"\n%@", sourceCode];
}

/**
 *  From Masonry
 */
static inline id HRMASBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

@end
