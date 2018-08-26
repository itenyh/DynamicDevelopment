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

typedef void (^TranslateCallBack)(NSString *jsScript, NSString *className, JSValue *error);

@interface HotComplileEngine () <FileTransferServiceBrowserDelegate>

@property (nonatomic, strong) JSContext *translatorJSContext;
@property (nonatomic, strong) JSValue *translator;
@property (nonatomic, strong) NSMutableArray *extensions;

@property (nonatomic, copy) NSString *jsSavePath;
@property (nonatomic, weak) UINavigationController *navController;

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
    
    [JPEngine handleException:^(NSString *msg) {
        NSLog(@"JPEngine Exception: %@", msg);
    }];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *file = [NSString stringWithFormat:@"%@/%@", bundlePath, @"constants_user.hogcs"];
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    [[JPEngine context] evaluateScript:content];
}

- (void)hotReloadProject {
    self.browser = [FileTransferServiceBrowser new];
    self.browser.delegate = self;
    [self.browser startBrowsering];
}

- (void)fileTransferServiceReceivedNewCode:(NSString *)code {
    NSLog(@"============= 【接收到源代码】 ============");
    NSTimeInterval receiveSourceCodeTime = [NSDate timeIntervalSinceReferenceDate];
    [self translateObj2Js:code callBack:^(NSString *jsScript, NSString *className, JSValue *error) {
        NSTimeInterval translateSourceCodeTime = [NSDate timeIntervalSinceReferenceDate];
        NSLog(@"============= 【翻译完毕：%f秒】 ============", translateSourceCodeTime - receiveSourceCodeTime);
        NSArray *errors = error.toArray;
        if (errors) {
            NSArray *errors = error.toArray;
            for (NSDictionary *error in errors) {
                NSLog(@"============= 【存在翻译错误】: %@ =============", error[@"msg"]);
            }
        }
        else {
            NSLog(@"============= 【开始更新】 ============");
            [self saveJsScript:jsScript];
            [self refresh:jsScript className:className];
            NSLog(@"============= 【更新完毕: %f秒】 ============", [NSDate timeIntervalSinceReferenceDate] - translateSourceCodeTime);
        }
    }];
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
- (void)loadMainJs {
    NSString *mainJsPath = [NSString stringWithFormat:@"%@/%@", self.jsSavePath, @"main.js"];
    [JPCleaner cleanAll];
    [JPEngine evaluateScriptWithPath:mainJsPath];
    [self finishEvaluate];
}

- (void)refresh:(NSString *)jsInput className:(NSString *)className {
    [JPCleaner cleanClass:className];
    [JPEngine evaluateScript:jsInput];
    [self finishEvaluate];
}

// Save JsScript translated from Objective-C
- (void)saveJsScript:(NSString *)script {
    if (self.jsSavePath) {
        NSString *mainJsPath = [NSString stringWithFormat:@"%@/%@", self.jsSavePath, @"main.js"];
        NSError *error;
        [script writeToFile:mainJsPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"error when write script: %@", error);
        }
    }
}

- (void)finishEvaluate {
    id appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = [appDelegate valueForKey:@"window"];
    UIViewController *rootViewController = window.rootViewController;
    if (!window || !rootViewController) {
        NSLog(@"No UIWindow or RootViewController Component");
        return;
    }
    
    UIViewController *containerViewController = [self findContainerController:rootViewController];
    if (!containerViewController) {
        Class vcClass = rootViewController.class;
        UIViewController *viewController = [[vcClass alloc] init];
        [rootViewController presentViewController:viewController animated:NO completion:nil];
    }
    else if ([containerViewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navController = ((UINavigationController *) containerViewController);
        Class vcClass = navController.topViewController.class;
        UIViewController *newVc = [[vcClass alloc] init];
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:newVc animated:NO];
    }
    else if ([containerViewController isKindOfClass:UITabBarController.class]) {
        NSLog(@"the top viewcontroller is kind of UITabBarController, presented the selected controller on it");
        UIViewController *selectedViewController = ((UITabBarController *)containerViewController).selectedViewController;
        Class vcClass = selectedViewController.class;
        UIViewController *viewController = [[vcClass alloc] init];
        [containerViewController presentViewController:viewController animated:NO completion:nil];
    }
    else {
        UIViewController *presentedViewController = containerViewController.presentedViewController;
        [containerViewController dismissViewControllerAnimated:NO completion:nil];
        Class vcClass = presentedViewController.class;
        UIViewController *viewController = [[vcClass alloc] init];
        [containerViewController presentViewController:viewController animated:NO completion:nil];
    }
}

- (UIViewController *)findContainerController:(UIViewController *)viewController {
    
    UIViewController *currentContainer;
    
    while (true) {
        UIViewController *next;
        if ([viewController isKindOfClass:UINavigationController.class]) {
            next = ((UINavigationController *)viewController).topViewController;
        }
        else if ([viewController isKindOfClass:UITabBarController.class]) {
            next = ((UITabBarController *)viewController).selectedViewController;
        }
        else {
            next = viewController.presentedViewController;
        }
        
        if (next) {
            currentContainer = viewController;
            viewController = next;
        }
        else {
            break;
        }
    }

    return currentContainer;
}

- (void)translateObj2Js:(NSString *)input callBack:(TranslateCallBack)callBack {
    NSLog(@"============= 【开始翻译】 ============");
    NSTimeInterval beginTranslateSourceCodeTime = [NSDate timeIntervalSinceReferenceDate];
    for (Class extension in self.extensions) {
        input = [extension performSelector:@selector(preProcessSourceCode:) withObject:input];
    }
    NSLog(@"============= 【拓展预处理完毕: %f】 ============", [NSDate timeIntervalSinceReferenceDate] - beginTranslateSourceCodeTime);
    [self.translator callWithArguments:@[input, callBack]];
}

#pragma - mark lazy load

- (NSMutableArray *)extensions {
    if (!_extensions) {
        _extensions = [NSMutableArray array];
    }
    return _extensions;
}

- (JSContext *)translatorJSContext {
    if (!_translatorJSContext) {
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"bundle" ofType:@"js"];
        NSError *error;
        NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
        _translatorJSContext = [JSContext new];
        [_translatorJSContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
            NSString *stacktrace = [exception objectForKeyedSubscript:@"stack"].toString;
            NSNumber *lineNumber = [exception objectForKeyedSubscript:@"line"].toNumber;
            NSLog(@"_translatorJSContext Exception: %@ \n lineNumber: %@ \n exception: %@", stacktrace, lineNumber, exception);
        }];
        [_translatorJSContext evaluateScript:scriptString];
    }
    return _translatorJSContext;
}
    
- (JSValue *)translator {
    if (!_translator) {
        _translator = [[self.translatorJSContext objectForKeyedSubscript:@"global"] objectForKeyedSubscript:@"convertor"];
    }
    return _translator;
}

@end

@interface HotComplileEngine (UIApplication)

@end

@implementation HotComplileEngine (UIApplication)

+ (void)load {
    HotComplileEngine *engine = [HotComplileEngine sharedInstance];
    engine.jsSavePath = @"/Users/mkeqi/Desktop/Working____/Demo/Demo/HotLoad/";
    [engine hotReloadProject];
}

@end

@interface HotComplileEngine (UIWindow)

@end

@implementation HotComplileEngine (UIWindow)

@end
