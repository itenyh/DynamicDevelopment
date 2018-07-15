//
//  AppDelegate.m
//  Bonjour
//
//  Created by Iten on 2018/7/12.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncSocket.h"
#import "FileTransferService.h"

@interface AppDelegate () <NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

//    [FileTransferService sharedInstance];
   
}

@end
