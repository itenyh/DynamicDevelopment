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
#import "TestViewController.h"

#include <stdlib.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[TestViewController new]];
    navController.navigationBar.hidden = YES;
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    float init = 200;
    int round = 1000000;
    float fee = 1.5;
    float award = 3;
    while (round-- > 0 && init > fee) {
        init -= fee;
        int r = arc4random_uniform(2);
        if (r > 0) init += award;
        NSLog(@"round: %d, init: %f", 1000000 - round, init);
    }
    
    return YES;
}

@end
