//
//  FileTransferServiceBrowser.m
//  Demo
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#define NETSERVICE_TYPE @"_itenyhhds._tcp"
#if (DEBUG)
#define NETSERVICE_NAME @"CodeTransfer_DEBUG"
#else
#define NETSERVICE_NAME @"CodeTransfer"
#endif

#import "FileTransferServiceBrowser.h"
#import "GCDAsyncSocket.h"
#import "SourceCode.h"

@interface FileTransferServiceBrowser () <NSNetServiceBrowserDelegate, NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (nonatomic, strong) NSNetService *service;
@property (nonatomic, strong) NSNetServiceBrowser *serviceBrowser;
@property (nonatomic, strong) NSMutableArray<NSNetService *> *services;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation FileTransferServiceBrowser

- (void)startBrowsering {
    [self.services removeAllObjects];
    self.serviceBrowser = [NSNetServiceBrowser new];
    self.serviceBrowser.delegate = self;
    [self.serviceBrowser searchForServicesOfType:NETSERVICE_TYPE inDomain:@""];
}

- (void)connect {
    self.service = self.services.firstObject;
    if (self.service) {
        self.service.delegate = self;
        [self.service resolveWithTimeout:3.0];
    }
}

- (BOOL)connectWithService:(NSNetService *)service {
    BOOL isConnected = NO;
    if (self.socket.isConnected) {
        isConnected = self.socket.isConnected;
        return isConnected;
    }
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    for (NSData *address in service.addresses) {
        NSError *err = nil;
        isConnected = [self.socket connectToAddress:address error:&err];
        if (isConnected) {
            break;
        }
    }
    
    return isConnected;
}

- (void)sendPacket:(id)packet {
    NSData *packetData = [NSKeyedArchiver archivedDataWithRootObject:packet];
    NSUInteger packetDataLength = packetData.length;
    NSMutableData *buffer = [NSMutableData dataWithBytes:&packetDataLength length:sizeof(UInt16)];
    [buffer appendData:packetData];
    [self.socket writeData:buffer withTimeout:-1 tag:0];
}

#pragma - mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (tag == 1) {
        UInt16 bodyLength = 0;
        [data getBytes:&bodyLength length:sizeof(UInt16)];
        NSLog(@"Header received with bodylength: %d", bodyLength);
        [self.socket readDataToLength:bodyLength withTimeout:-1 tag:2];
    }
    else if (tag == 2) {
        SourceCode *sourceCode = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"SourceCode received: %@", sourceCode.code);
        if (self.delegate && [self.delegate respondsToSelector:@selector(fileTransferServiceReceivedNewCode:)]) {
            [self.delegate fileTransferServiceReceivedNewCode:sourceCode.code];
        }
        [self.socket readDataToLength:sizeof(UInt16) withTimeout:-1 tag:1];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"Socket connected to host");
    [self.socket readDataToLength:sizeof(UInt16) withTimeout:-1 tag:1];
}

#pragma - mark NSNetServiceBrowserDelegate NSNetServiceDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    [self.services addObject:service];
    [self connect];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    if ([self connectWithService:sender]) {
        NSLog(@"Did connect with service: %@", NETSERVICE_NAME);
    } else {
        NSLog(@"Error connecting with service");
    }
    
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *,NSNumber *> *)errorDict {
    self.service.delegate = nil;
}

#pragma - mark LazyLoad

- (NSMutableArray<NSNetService *> *)services {
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}

@end
