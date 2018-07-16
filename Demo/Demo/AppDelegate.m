//
//  AppDelegate.m
//  Demo
//
//  Created by Iten on 2018/7/3.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "AppDelegate.h"
#import "HotComplileEngine.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    navController.navigationBar.hidden = YES;
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
//    [[HotComplileEngine sharedInstance] watchAndHotReload:@"ViewController.m"];
    [[HotComplileEngine sharedInstance] hotReloadProject];
    
//    UIButton *button = [UIButton new];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//    [self.window addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.window);
//    }];
//    
//    [button setTitle:@"eval" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(eval) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor redColor];
    
    NSFileManager *filemgr;
    NSString *currentpath;
    
    filemgr = [[NSFileManager alloc] init];
    
    currentpath = [[NSBundle mainBundle] pathForResource:@"system_macro" ofType:@"js"];
    NSLog(@"currentpath: %@", currentpath);
    
    return YES;
}

- (void)eval {
//    [[HotComplileEngine sharedInstance] loadRefresh];
}

@end
