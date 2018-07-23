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
#import "FileTransferServiceBrowser.h"

#import "AppDelegate.h"

typedef void (^TranslateCallBack)(NSString *jsScript, NSString *className);

@interface HotComplileEngine () <FileTransferServiceBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *extensions;

@property (nonatomic, strong) NSMutableArray *watchDogs;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSDate *fileLastModifyDate;

@property (nonatomic, strong) FileTransferServiceBrowser *browser;

@end

@implementation HotComplileEngine

+ (instancetype)sharedInstance {
    static HotComplileEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HotComplileEngine new];
        [instance setupEngine];
    });
    return instance;
}

- (void)setupEngine {
    
    [JPEngine startEngine];
    [self addExtensions:@[@"JPBlock", @"JPCFunction", @"JPCGFunction", @"JPMasonry", @"JPNSFunction"]];
    
//    //load global utils
//    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"system_macro" ofType:@"js"];
//    NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
//    [JPEngine evaluateScript:scriptString];
    
    [JPEngine handleException:^(NSString *msg) {
        NSLog(@"JPEngine Exception: %@", msg);
    }];
}

- (void)hotReloadProject {
    self.browser = [FileTransferServiceBrowser new];
    self.browser.delegate = self;
    [self.browser startBrowsering];
}

- (void)fileTransferServiceReceivedNewCode:(NSString *)code {
    [self translateObj2Js:code callBack:^(NSString *jsScript, NSString *className) {
        [self saveJsScript:jsScript];
        [self refresh:jsScript className:className];
    }];
}

#pragma - mark Watch Single File Model

- (void)watchAndHotReload:(NSString *)filename {
    
    self.watchDogs = [NSMutableArray new];
#if TARGET_IPHONE_SIMULATOR
    self.rootPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ProjectPath"];
#else
    self.rootPath = [[NSBundle mainBundle] bundlePath];
#endif
    
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
        NSString *objFile = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        [self translateObj2Js:objFile callBack:^(NSString *jsScript, NSString *className) {
            [self refresh:jsScript className:className];
        }];
        self.fileLastModifyDate = curDate;
    }];
    [watchDog start];
    [self.watchDogs addObject:watchDog];
}

#pragma - mark Util Methods

- (void)addExtensions:(NSArray *)extensionNames {
    [JPEngine addExtensions:extensionNames];
    for (NSString *extension in extensionNames) {
        Class extensionClass = NSClassFromString(extension);
        [self.extensions addObject:extensionClass];
    }
}

// Load JsScript translated from Objective-C
+ (void)loadMainJs {
    NSString *rootPath ;
#if TARGET_IPHONE_SIMULATOR
    rootPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ProjectPath"];
#else
    rootPath = [[NSBundle mainBundle] bundlePath];
#endif
    NSString *mainJsPath = [NSString stringWithFormat:@"%@/%@", rootPath, @"HotLoad/Convertor/main.js"];
    [JPCleaner cleanAll];
    [JPEngine evaluateScriptWithPath:mainJsPath];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * navController = (UINavigationController *)appDelegate.window.rootViewController;
    Class class = navController.topViewController.class;
    UIViewController *newVc = [[class alloc] init];
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:newVc animated:NO];
    
}

// Save JsScript translated from Objective-C
- (void)saveJsScript:(NSString *)script {
    NSString *rootPath ;
#if TARGET_IPHONE_SIMULATOR
    rootPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ProjectPath"];
#else
    rootPath = [[NSBundle mainBundle] bundlePath];
#endif
    NSString *mainJsPath = [NSString stringWithFormat:@"%@/%@", rootPath, @"HotLoad/Convertor/main.js"];
    NSError *error;
    [script writeToFile:mainJsPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error when write script: %@", error);
    }
}

- (void)refresh:(NSString *)jsInput className:(NSString *)className {
    
    [JPCleaner cleanClass:className];
    [JPEngine evaluateScript:jsInput];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * navController = (UINavigationController *)appDelegate.window.rootViewController;
    Class class = navController.topViewController.class;
    UIViewController *newVc = [[class alloc] init];
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:newVc animated:NO];
    
}

- (void)translateObj2Js:(NSString *)input callBack:(TranslateCallBack)callBack {
    
    for (Class extension in self.extensions) {
        input = [extension performSelector:@selector(preProcessSourceCode:) withObject:input];
    }
    
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"bundle" ofType:@"js"];
    NSError *error;
    NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
    JSContext *context = [JSContext new];
    [context setExceptionHandler:^(JSContext *context, JSValue *exception) {
        NSString *stacktrace = [exception objectForKeyedSubscript:@"stack"].toString;
        NSNumber *lineNumber = [exception objectForKeyedSubscript:@"line"].toNumber;
        NSLog(@"stacktrace: %@ \n lineNumber: %@ \n exception: %@", stacktrace, lineNumber, exception);
    }];
    [context evaluateScript:scriptString];
    JSValue *convertor = [[context objectForKeyedSubscript:@"global"] objectForKeyedSubscript:@"convertor"];
    [convertor callWithArguments:@[input, callBack]];
}

#pragma - mark lazy load

- (NSMutableArray *)extensions {
    if (!_extensions) {
        _extensions = [NSMutableArray array];
    }
    return _extensions;
}

@end
