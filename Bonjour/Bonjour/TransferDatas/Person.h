//
//  Person.h
//  Bonjour
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;

- (instancetype)initWithName:(NSString *)name age:(int)age;

@end
