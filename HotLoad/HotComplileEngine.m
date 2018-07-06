//
//  HotComplileEngine.m
//  SmallCity
//
//  Created by Iten on 2018/6/21.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "HotComplileEngine.h"
#import "SGDirWatchdog.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JPEngine.h"
#import "JPCleaner.h"

#import "AppDelegate.h"

typedef void (^TranslateCallBack)(NSString *result);

@interface HotComplileEngine ()

@property (nonatomic, strong) NSMutableArray *watchDogs;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSDate *fileLastModifyDate;
@property (nonatomic, copy) NSString *result;

@end

@implementation HotComplileEngine

+ (instancetype)sharedInstance {
    static HotComplileEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HotComplileEngine new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.watchDogs = [NSMutableArray new];
#if TARGET_IPHONE_SIMULATOR
        self.rootPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ProjectPath"];
#else
        self.rootPath = [[NSBundle mainBundle] bundlePath];
#endif
        [JPEngine startEngine];
        
        //add extensions after startEngine
        [JPEngine addExtensions:@[@"JPBlock", @"JPCFunction"]];
        
        [JPEngine handleException:^(NSString *msg) {
            NSLog(@"JPEngine Exception: %@", msg);
        }];
    }
    return self;
}

- (void)startEngine:(NSString *)filename {
    self.filePath = [NSString stringWithFormat:@"%@/%@", self.rootPath, filename];
    [self watchFile:[NSString stringWithFormat:@"%@/%@", self.rootPath, [filename stringByDeletingLastPathComponent]]];
}


- (void)watchFile:(NSString *)filePath {
    SGDirWatchdog *watchDog = [[SGDirWatchdog alloc] initWithPath:filePath update:^{
        NSError *error;
        NSURL *fileURL = [NSURL fileURLWithPath:self.filePath];
        NSDictionary *fileRes = [fileURL resourceValuesForKeys:@[NSURLContentModificationDateKey] error:&error];
        if (error) { NSLog(@"filePathURL error: %@", error); }
        NSDate *curDate = [fileRes objectForKey:NSURLContentModificationDateKey];
        if (self.fileLastModifyDate && [curDate compare: self.fileLastModifyDate] != NSOrderedDescending) { return; }
        [self translateObj2Js:^(NSString *result) {
            result = [self loadMacro:result];
            self.result = result;
            [self refresh];
        }];
        self.fileLastModifyDate = curDate;
    }];
    [watchDog start];
    [self.watchDogs addObject:watchDog];
}

- (void)refresh {
    
    NSString *mainJsPath = [NSString stringWithFormat:@"%@/%@", self.rootPath, @"HotLoad/src/main.js"];
    [self.result writeToFile:mainJsPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [JPCleaner cleanAll];
    [JPEngine evaluateScriptWithPath:mainJsPath];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * navController = (UINavigationController *)appDelegate.window.rootViewController;
    Class class = navController.topViewController.class;
    UIViewController *newVc = [[class alloc] init];
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:newVc animated:NO];
    
}

- (void)loadRefresh {
    NSString *mainJsPath = [NSString stringWithFormat:@"%@/%@", self.rootPath, @"HotLoad/src/main.js"];
    [JPCleaner cleanAll];
    [JPEngine evaluateScriptWithPath:mainJsPath];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * navController = (UINavigationController *)appDelegate.window.rootViewController;
    Class class = navController.topViewController.class;
    UIViewController *newVc = [[class alloc] init];
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:newVc animated:NO];
}

- (void)translateObj2Js:(TranslateCallBack)callBack {
    NSString *scriptPath = [NSString stringWithFormat:@"%@/%@", self.rootPath, @"HotLoad/src/bundle.js"];
    NSError *error;
    NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
    JSContext *context = [JSContext new];
    [context setExceptionHandler:^(JSContext *context, JSValue *exception) {
        // type of String
        NSString *stacktrace = [exception objectForKeyedSubscript:@"stack"].toString;
        // type of Number
        NSNumber *lineNumber = [exception objectForKeyedSubscript:@"line"].toNumber;
        NSLog(@"stacktrace: %@ \n lineNumber: %@ \n exception: %@", stacktrace, lineNumber, exception);
    }];
    
    //    NSLog(@"scriptPath: %@ script: %@", scriptPath, scriptString);
    [context evaluateScript:scriptString];
    JSValue *convertor = [[context objectForKeyedSubscript:@"global"] objectForKeyedSubscript:@"convertor"];
    NSString *objFile = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:&error];
    [convertor callWithArguments:@[objFile, callBack]];
}

- (NSString *)loadMacro:(NSString *)script {
    NSString *macroString = @"include('system_macro.js');";
    return [NSString stringWithFormat:@"%@\n%@", macroString, script];
}

@end
