//
//  Packet.m
//  Bonjour
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "Packet.h"

@interface Packet () <NSCoding>

@property (nonatomic, assign) ObjectType objectType;
@property (nonatomic, strong) id object;

@end

@implementation Packet

- (instancetype)initWith:(ObjectType)objectType object:(id)object {
    self = [super init];
    if (self) {
        self.objectType = objectType;
        self.object = object;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.objectType = [aDecoder decodeIntegerForKey:@"objectType"];
        self.object = [aDecoder decodeObjectForKey:@"object"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.objectType forKey:@"objectType"];
    [aCoder encodeObject:self.object forKey:@"object"];
}

//- (Element *)getObject<Element> {
//    return self.object;
//}

@end
