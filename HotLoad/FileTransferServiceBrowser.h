//
//  FileTransferServiceBrowser.h
//  Demo
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileTransferServiceBrowserDelegate <NSObject>

- (void)fileTransferServiceReceivedNewCode:(NSString *)code;

@end

@interface FileTransferServiceBrowser : NSObject

@property (nonatomic, weak) id<FileTransferServiceBrowserDelegate> delegate;

- (void)startBrowsering;

@end
