//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "JPEngine.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *subView;

@end

@implementation ViewController

#pragma hotdev exclusive

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.subView];
    
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.center.equalTo(self.view);
    }];
    
//    CGSize size;
//     __typeof__(size);

//    #define MASBoxValue(value) _MASBoxValue(@encode(__typeof__((value))), (value))
//    NSValue *value = MMASBoxValue(@encode(CGSize), CGSizeMake(10, 20));
//    NSLog(@"value: %@", value);
//    int sum = addemUp(1, 2, 3, 0);
//    NSLog(@"sum: %d", sum);
//    [self MMASBoxValue:<#(NSString *)#> struct:<#(void *)#>]
//     NSSting *a = @encode(CGSize);
//    funcC([self createPoint]);
//    CGSize size = CGSizeMake(12, 32);
//    NSLog(@"%@", [self funD:&size]);
    
}

//- (void *)createStuctPoint {
//    CGSize size = CGSizeMake(12, 10);
//    return &size;
//}

//- (void *)createPoint {
//    return "{CGSize=dd}";
//}

/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */

//- (void)MMASBoxValue:(NSString *)type struct:(void *)value {
//    CGSize size = (CGSize)value;
////    NSLog(@"size: %@", size);
//}

//id MMASBoxValue(const char *type, ...) {
//    va_list v;
//    va_start(v, type);
//    
//    id obj = nil;
//    if (strcmp(type, @encode(id)) == 0) {
//        id actual = va_arg(v, id);
//        obj = actual;
//    } else if (strcmp(type, @encode(CGPoint)) == 0) {
//        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
//        obj = [NSValue value:&actual withObjCType:type];
//    } else if (strcmp(type, @encode(CGSize)) == 0) {
//        CGSize actual = (CGSize)va_arg(v, CGSize);
//        obj = [NSValue value:&actual withObjCType:type];
//    } else if (strcmp(type, @encode(MASEdgeInsets)) == 0) {
//        MASEdgeInsets actual = (MASEdgeInsets)va_arg(v, MASEdgeInsets);
//        obj = [NSValue value:&actual withObjCType:type];
//    } else if (strcmp(type, @encode(double)) == 0) {
//        double actual = (double)va_arg(v, double);
//        obj = [NSNumber numberWithDouble:actual];
//    } else if (strcmp(type, @encode(float)) == 0) {
//        float actual = (float)va_arg(v, double);
//        obj = [NSNumber numberWithFloat:actual];
//    } else if (strcmp(type, @encode(int)) == 0) {
//        int actual = (int)va_arg(v, int);
//        obj = [NSNumber numberWithInt:actual];
//    } else if (strcmp(type, @encode(long)) == 0) {
//        long actual = (long)va_arg(v, long);
//        obj = [NSNumber numberWithLong:actual];
//    } else if (strcmp(type, @encode(long long)) == 0) {
//        long long actual = (long long)va_arg(v, long long);
//        obj = [NSNumber numberWithLongLong:actual];
//    } else if (strcmp(type, @encode(short)) == 0) {
//        short actual = (short)va_arg(v, int);
//        obj = [NSNumber numberWithShort:actual];
//    } else if (strcmp(type, @encode(char)) == 0) {
//        char actual = (char)va_arg(v, int);
//        obj = [NSNumber numberWithChar:actual];
//    } else if (strcmp(type, @encode(bool)) == 0) {
//        bool actual = (bool)va_arg(v, int);
//        obj = [NSNumber numberWithBool:actual];
//    } else if (strcmp(type, @encode(unsigned char)) == 0) {
//        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
//        obj = [NSNumber numberWithUnsignedChar:actual];
//    } else if (strcmp(type, @encode(unsigned int)) == 0) {
//        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
//        obj = [NSNumber numberWithUnsignedInt:actual];
//    } else if (strcmp(type, @encode(unsigned long)) == 0) {
//        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
//        obj = [NSNumber numberWithUnsignedLong:actual];
//    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
//        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
//        obj = [NSNumber numberWithUnsignedLongLong:actual];
//    } else if (strcmp(type, @encode(unsigned short)) == 0) {
//        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
//        obj = [NSNumber numberWithUnsignedShort:actual];
//    }
//    va_end(v);
//    return obj;
//}
//
//
//// sum all the integers passed in.  Stopping if it's zero
//int addemUp (int firstNum, ...) {
//    va_list args;
//    int sum = firstNum;
//    int number;
//    va_start (args, firstNum);
//    while (1) {
//        number = va_arg (args, int);
//        sum += number;
//        if (number == 0) {
//            break; }
//    }
//    va_end (args);
//    return sum;
//} // addemUp
//
//int funcA(CGSize size) {
//    NSLog(@"funcA object: %@", NSStringFromCGSize(size));
//    return 13;
//    
//}
//
//- (void)funcB:(CGSize)size {
//    NSLog(@"funcB object: %@", NSStringFromCGSize(size));
//}
//
//- (void)funcD:(NSString *)str {
//    NSLog(@"funcB object: %@", str);
//}
//
//int funcC(const void *str) {
//    
//    NSLog(@"%s", str);
//    return 13;
//    
//}
//
//- (NSString *)funD:(void *)ttt {
//    char *str = @encode(typeof(ttt));
//    return [NSString stringWithUTF8String:str];
//}

+ (void)fuck:(id)arg {
    
}

#pragma - mark LazyLoad

- (UIView *)subView {
    if (!_subView) {
        _subView = [UIView new];
        _subView.backgroundColor = [UIColor orangeColor];
    }
    return _subView;
}

@end
