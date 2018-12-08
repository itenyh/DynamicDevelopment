//
//  SourceCode.m
//  Bonjour
//
//  Created by mke Qi on 2018/7/15.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "SourceCode.h"

@interface SourceCode () <NSCoding>

@end

@implementation SourceCode

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if(self.code) [aCoder encodeObject:self.code forKey:@"code"];
}

@end
