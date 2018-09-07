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

#import "HRIndicatorView.h"
#import "HRInfoViewController.h"

typedef void (^TranslateCallBack)(NSString *jsScript, NSString *className, JSValue *error);

@interface HotComplileEngine () <FileTransferServiceBrowserDelegate, HRIndicatorViewDelegate>

@property (nonatomic, strong) JSContext *translatorJSContext;
@property (nonatomic, strong) JSValue *translator;
@property (nonatomic, strong) NSMutableArray *extensions;

@property (nonatomic, copy) NSString *jsSavePath;
@property (nonatomic, weak) UINavigationController *navController;

@property (nonatomic, strong) FileTransferServiceBrowser *browser;
@property (nonatomic, strong) HRIndicatorView *indicatorView;
@property (nonatomic, strong) HRInfoViewController *infoController;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation HotComplileEngine

+ (void)load {
    HotComplileEngine *engine = [HotComplileEngine sharedInstance];
    engine.jsSavePath = @"/Users/iten/Desktop/iOS_BigData/cqBigData/cqBigData/Debug/HotLoad";
    [engine hotReloadProject];
    
    [engine performSelector:@selector(setupUI) withObject:nil afterDelay:1];
}

- (void)setupUI {
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (!appDelegate) { return; }
    
    self.window = [appDelegate valueForKey:@"window"];
    if (!self.window) { return; }
    
    [self.window addSubview:self.indicatorView];
}


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
        self.indicatorView.state = HRIndicatorViewError;
        [self.infoController appendInfo:[NSString stringWithFormat:@"JPEngine Exception: %@", msg]];
    }];
    
    NSString *userConstant = [self loadBundleFile:@"user_constant.hr"];
    [[JPEngine context] evaluateScript:userConstant];
}

- (void)hotReloadProject {
    self.browser = [FileTransferServiceBrowser new];
    self.browser.delegate = self;
    [self.browser startBrowsering];
}

#pragma - mark HRIndicatorViewDelegate

- (void)HRIndicatorViewDelegateClicked:(id)view {
    UIViewController *rootViewController = self.window.rootViewController;
    if (!self.window || !rootViewController) {
        NSLog(@"No UIWindow or RootViewController Component");
        return;
    }
    if (self.infoController.isPresented) {
        [self.infoController dismissViewControllerAnimated:YES completion:nil];
        self.infoController.isPresented = NO;
    }
    else {
        [rootViewController presentViewController:self.infoController animated:YES completion:nil];
        self.infoController.isPresented = YES;
    }
}

#pragma - mark FileTransferServiceBrowserDelegate

- (void)fileTransferServiceReceivedNewCode:(NSString *)code {
    
    [self.infoController clear];
    self.indicatorView.state = HRIndicatorViewWorking;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.infoController appendInfo:@"============= 【接收到源代码】 ============"];
        NSTimeInterval receiveSourceCodeTime = [NSDate timeIntervalSinceReferenceDate];
        [self translateObj2Js:code callBack:^(NSString *jsScript, NSString *className, JSValue *error) {
            NSTimeInterval translateSourceCodeTime = [NSDate timeIntervalSinceReferenceDate];
            [self.infoController appendInfo:[NSString stringWithFormat:@"============= 【翻译完毕：%f秒】 ============", translateSourceCodeTime - receiveSourceCodeTime]];
            NSArray *errors = error.toArray;
            if (errors) {
                self.indicatorView.state = HRIndicatorViewError;
                NSArray *errors = error.toArray;
                for (NSDictionary *error in errors) {
                    [self.infoController appendInfo:[NSString stringWithFormat:@"============= 【存在翻译错误】: %@ =============", error[@"msg"]]];
                }
            }
            else {
                self.indicatorView.state = HRIndicatorViewReady;
                [self saveJsScript:jsScript];
                [self.infoController appendInfo:@"============= 【开始更新】 ============"];
                [self refresh:jsScript className:className];
                 [self reloadCurrentView];
                [self.infoController appendInfo:[NSString stringWithFormat:@"============= 【更新完毕: %f秒】 ============", [NSDate timeIntervalSinceReferenceDate] - translateSourceCodeTime]];
            }
        }];
        
    });

}

- (void)fileTransferServiceReady {
    self.indicatorView.state = HRIndicatorViewReady;
}

- (void)fileTransferServiceUnReady {
    self.indicatorView.state = HRIndicatorViewUnReady;
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
    [self reloadCurrentView];
}

- (void)refresh:(NSString *)jsInput className:(NSString *)className {
    [JPCleaner cleanClass:className];
    [JPEngine evaluateScript:jsInput];
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

- (void)translateObj2Js:(NSString *)input callBack:(TranslateCallBack)callBack {
    [self.infoController appendInfo:@"============= 【开始翻译】 ============"];
    NSTimeInterval beginTranslateSourceCodeTime = [NSDate timeIntervalSinceReferenceDate];
    //全局宏替换
    
    //拓展宏替换
    for (Class extension in self.extensions) {
        input = [extension performSelector:@selector(preProcessSourceCode:) withObject:input];
    }
    [self.infoController appendInfo:[NSString stringWithFormat:@"============= 【拓展预处理完毕: %f】 ============", [NSDate timeIntervalSinceReferenceDate] - beginTranslateSourceCodeTime]];
    [self.translator callWithArguments:@[input, callBack]];
}

- (NSString *)loadBundleFile:(NSString *)filename {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *file = [NSString stringWithFormat:@"%@/%@", bundlePath, filename];
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    return content;
}

#pragma - mark View Refresh

- (void)reloadCurrentView {
    
    if (self.infoController.isPresented) {
        [self.infoController dismissViewControllerAnimated:YES completion:^{
            [self reloadVisibleViewController];
        }];
        self.infoController.isPresented = NO;
    }
    else {
        [self reloadVisibleViewController];
    }
    
}

- (void)reloadVisibleViewController {
    UIViewController *rootViewController = self.window.rootViewController;
    if (!self.window || !rootViewController) {
        NSLog(@"No UIWindow or RootViewController Component");
        return;
    }
    
    UIViewController *containerViewController = [self findContainerController:rootViewController];
    if (!containerViewController) {
        Class class = rootViewController.class;
        UIViewController *viewController = [[class alloc] init];
        [rootViewController presentViewController:viewController animated:NO completion:nil];
    }
    else if ([containerViewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navController = ((UINavigationController *) containerViewController);
        Class class = navController.topViewController.class;
        UIViewController *newVc = [[class alloc] init];
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:newVc animated:NO];
    }
    else if ([containerViewController isKindOfClass:UITabBarController.class]) {
        UIViewController *selectedViewController = ((UITabBarController *)containerViewController).selectedViewController;
        Class class = selectedViewController.class;
        UIViewController *viewController = [[class alloc] init];
        [containerViewController presentViewController:viewController animated:NO completion:nil];
    }
    else {
        UIViewController *presentedViewController = containerViewController.presentedViewController;
        [containerViewController dismissViewControllerAnimated:NO completion:nil];
        Class class = presentedViewController.class;
        UIViewController *viewController = [[class alloc] init];
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

#pragma - mark lazy load

- (NSMutableArray *)extensions {
    if (!_extensions) {
        _extensions = [NSMutableArray array];
    }
    return _extensions;
}
    
- (JSContext *)translatorJSContext {
    if (!_translatorJSContext) {
        NSString *scriptString = [self loadBundleFile:@"convertor_bundle_hr.js"];
        _translatorJSContext = [JSContext new];
        [_translatorJSContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
//            NSString *stacktrace = [exception objectForKeyedSubscript:@"stack"].toString;
//            NSNumber *lineNumber = [exception objectForKeyedSubscript:@"line"].toNumber;
//            NSLog(@"_translatorJSContext Exception: %@ \n lineNumber: %@ \n exception: %@", stacktrace, lineNumber, exception);
            NSLog(@"error should not come here");
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

- (HRIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [HRIndicatorView new];
        _indicatorView.delegate = self;
    }
    return _indicatorView;
}

- (HRInfoViewController *)infoController {
    if (!_infoController) {
        _infoController = [HRInfoViewController new];
    }
    return _infoController;
}

@end
