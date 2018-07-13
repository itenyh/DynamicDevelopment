//
//  AppDelegate.m
//  Bonjour
//
//  Created by Iten on 2018/7/12.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncSocket.h"

@interface AppDelegate () <NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSNetService *netService;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSMutableArray *connectedSockets;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *err = nil;
    if ([self.asyncSocket acceptOnPort:0 error:&err]) {
        //Get the port created by OS
        UInt16 port = [self.asyncSocket localPort];
        
        //Publish a Bonjour service
        self.netService = [[NSNetService alloc] initWithDomain:@"local." type:@"_chatter._tcp." name:@"test" port:port];
        self.netService.delegate = self;
        [self.netService publish];
    }
    
   
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void) netService: (NSNetService *) sender
      didNotPublish: (NSDictionary *) errorDict {
    NSLog (@"failed to publish net service: %@", errorDict);
} // didNotPublish

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog (@"success to publish net service");
//    [self IPFromData:sender.addresses[0]];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"Accepted new socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    
    [self.connectedSockets addObject:newSocket];
    
    NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [newSocket writeData:welcomeData withTimeout:-1 tag:1];
    [newSocket readDataToData:welcomeMsg withTimeout:5 tag:0];
    // The newSocket automatically inherits its delegate & delegateQueue from its parent.
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
//    [connectedSockets removeObject:sock];
    NSLog(@"disconnected socket: %@", err);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (NSMutableArray *)connectedSockets {
    if (!_connectedSockets) {
        _connectedSockets = [NSMutableArray array];
    }
    return _connectedSockets;
}

@end
