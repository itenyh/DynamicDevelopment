//
//  FileTransferService.h
//  Bonjour
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTransferService : NSObject

+ (instancetype)sharedInstance;
- (void)sendCode:(NSString *)code;
- (void)startBroadcast;

@end
