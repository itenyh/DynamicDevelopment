//
//  FileTransferService.m
//  Bonjour
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

#import "FileTransferService.h"
#import "GCDAsyncSocket.h"
#import "SourceCode.h"

@interface FileTransferService () <NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (nonatomic, strong) NSNetService *service;
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSMutableSet<GCDAsyncSocket *> *acceptedSockets;

@end

@implementation FileTransferService

+ (instancetype)sharedInstance
{
    static FileTransferService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FileTransferService new];
    });
    return sharedInstance;
}

- (void)startBroadcast {
    NSError *err = nil;
    if (!self.service && [self.socket acceptOnPort:0 error:&err]) {
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

- (void)sendCode:(NSString *)code {
    for (GCDAsyncSocket *socket in self.acceptedSockets) {
        SourceCode *sourceCode = [SourceCode new];
        sourceCode.code = code;
        [self _sendPacket:sourceCode socket:socket];
    }
}

- (void)_sendPacket:(id)packet socket:(GCDAsyncSocket *)socket {
    NSData *packetData = [NSKeyedArchiver archivedDataWithRootObject:packet];
    NSUInteger packetDataLength = packetData.length;
    NSMutableData *buffer = [NSMutableData dataWithBytes:&packetDataLength length:sizeof(UInt16)];
    [buffer appendData:packetData];
    [socket writeData:buffer withTimeout:-1 tag:0];
}

#pragma - mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"New Socket accepted");
    [self.acceptedSockets addObject:newSocket];
    newSocket.delegate = self;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self.acceptedSockets removeObject:sock];
    NSLog(@"Socket: %@ disconnected", sock);
}

#pragma - mark NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog (@"Success to publish net service");
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict {
    NSLog (@"Fail to publish net service: %@", errorDict);
}

#pragma - mark LazyLoad

- (GCDAsyncSocket *)socket {
    if (!_socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _socket;
}

- (NSMutableSet *)acceptedSockets {
    if (!_acceptedSockets) {
        _acceptedSockets = [NSMutableSet set];
    }
    return _acceptedSockets;
}

@end
