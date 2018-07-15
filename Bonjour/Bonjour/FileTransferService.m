//
//  FileTransferService.m
//  Bonjour
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#define NETSERVICE_TYPE @"_itenyhhds._tcp"
#define NETSERVICE_NAME @"CodeTransfer"

#import "FileTransferService.h"
#import "GCDAsyncSocket.h"
#import "SourceCode.h"

@interface FileTransferService () <NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (nonatomic, strong) NSNetService *service;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation FileTransferService

+ (instancetype)sharedInstance
{
    static FileTransferService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FileTransferService new];
        [sharedInstance startBroadcast];
    });
    return sharedInstance;
}

- (void)startBroadcast {
    NSError *err = nil;
    if ([self.socket acceptOnPort:0 error:&err]) {
        //Get the port created by OS
        UInt16 port = [self.socket localPort];
        
        //Publish a Bonjour service
        self.service = [[NSNetService alloc] initWithDomain:@"" type:NETSERVICE_TYPE name:NETSERVICE_NAME port:port];
        self.service.delegate = self;
        [self.service publish];
    }
    else {
        NSLog(@"startBroadcast error: %@", err);
    }
}

- (void)sendPacket:(id)packet {
    NSData *packetData = [NSKeyedArchiver archivedDataWithRootObject:packet];
    NSUInteger packetDataLength = packetData.length;
    NSMutableData *buffer = [NSMutableData dataWithBytes:&packetDataLength length:sizeof(UInt16)];
    [buffer appendData:packetData];
    [self.socket writeData:buffer withTimeout:-1 tag:0];
}

- (void)sendCode:(NSString *)code {
    if (self.socket) {
        SourceCode *sourceCode = [SourceCode new];
        sourceCode.code = code;
        [self sendPacket:sourceCode];
    }
}

#pragma - mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"Socket accepted");
    self.socket = newSocket;
    self.socket.delegate = self;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (self.socket == sock) {
        NSLog(@"Socket disconnected");
        self.socket.delegate = nil;
        self.socket = nil;
    }
}

#pragma - mark NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog (@"success to publish net service");
}

#pragma - mark LazyLoad

- (GCDAsyncSocket *)socket {
    if (!_socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _socket;
}

@end
