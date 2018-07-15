//
//  SourceEditorCommand.m
//  CodeTransport
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "FileTransferService.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    NSString *code = invocation.buffer.completeBuffer;
    [[FileTransferService sharedInstance] sendCode:code];
    
    completionHandler(nil);
}

@end
