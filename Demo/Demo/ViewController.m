//
//  ViewController.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController () <NSNetServiceBrowserDelegate, NSNetServiceDelegate, GCDAsyncSocketDelegate>
{
    NSNetServiceBrowser *browser;
    NSMutableArray *services;
    NSNetService *netService;
    NSData *address;
}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    browser = [NSNetServiceBrowser new];
    browser.delegate = self;
    services = [NSMutableArray array];
    
    [browser searchForServicesOfType:@"_chatter._tcp." inDomain:@"local."];
    NSLog (@"Begun browsing: %@", browser);
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    netService = service;
    NSLog (@"Adding new service: %@ %@ %ld", netService.name, netService.hostName, netService.port);
    netService.delegate = self;
    [netService resolveWithTimeout:30];
//    [services addObject: service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog (@"Removing service");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog (@"Adding new domainString: %@", domainString);
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSArray *addresses = [sender addresses];
    address = [addresses lastObject];
    if (self.asyncSocket == nil)
    {
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        [self connectToAddress:address];
    }
    
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *,NSNumber *> *)errorDict {
    NSLog(@"resolve fail: %@", errorDict);
}

- (void)connectToAddress:(NSData *)address
{
   
        NSError *err = nil;
        if ([self.asyncSocket connectToAddress:address error:&err])
        {
            NSData *data = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];
            [self.asyncSocket writeData:data withTimeout:2 tag:10];
        }
        else
        {
            NSLog(@"Unable to connect: %@", err);
        }


}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"didWriteDataWithTag: %ld", tag);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"SocketDidDisconnect:WithError: %@", err);
  
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"11111111%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

//- (NSString *)IPFromData:(NSData*)data
//{
//    struct sockaddr_in *addr = (struct sockaddr_in*)[data bytes];
//    if (addr->sin_family == AF_INET) {
//        NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(addr->sin_addr)];
//        in_port_t port = addr->sin_port;
//        NSLog(@"%d", port);
//        return ip;
//    }
//    return @"no ip address";
//}

@end
