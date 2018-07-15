//
//  SourceEditorExtension.m
//  CodeTransport
//
//  Created by mke Qi on 2018/7/14.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "SourceEditorExtension.h"
#import "FileTransferService.h"

@implementation SourceEditorExtension


- (void)extensionDidFinishLaunching
{
    [FileTransferService sharedInstance];
}


/*
- (NSArray <NSDictionary <XCSourceEditorCommandDefinitionKey, id> *> *)commandDefinitions
{
    // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
    return @[];
}
*/

@end
