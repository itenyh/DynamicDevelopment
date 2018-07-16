//
//  FileSystemWatch.h
//  SmallCity
//
//  Created by Iten on 2018/6/21.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemWatch : NSObject

- (void)watchFileAtPath:(NSString*)path target:(id)target action:(SEL)action;
- (void)stopWatching;

@end
