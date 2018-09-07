//
//  NSArray+JPArray.m
//  Demo
//
//  Created by Iten on 2018/9/7.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "JPCollection.h"

@implementation NSArray (JPCollection)

- (id)jp_element:(NSInteger)index {
    return [self objectAtIndex:index];
}

@end

@implementation NSMutableArray (JPCollection)

- (void)setJp_element:(NSInteger)index obj:(id)obj {
    [self replaceObjectAtIndex:index withObject:obj];
}

@end

@implementation NSDictionary (JPCollection)

- (id)jp_element:(id)key {
    return [self objectForKey:key];
}

@end

@implementation NSMutableDictionary (JPCollection)

- (void)setJp_element:(id)key obj:(id)obj {
    [self setObject:obj forKey:key];
}

@end


