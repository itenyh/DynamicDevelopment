//
//  PersonPacket.m
//  Bonjour
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "PersonPacket.h"

@implementation PersonPacket

- (instancetype)initWithPerson:(Person *)person{
    self = [super init];
    if (self) {
        self.person = person;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        NSString *name = [aDecoder decodeObjectForKey:@"name"];
        int age = [aDecoder decodeIntForKey:@"age"];
        self.person = [[Person alloc] initWithName:name age:age];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if(self.person.name) [aCoder encodeObject:self.person.name forKey:@"name"];
    if(self.person.age) [aCoder encodeInt:self.person.age forKey:@"age"];
}

@end
