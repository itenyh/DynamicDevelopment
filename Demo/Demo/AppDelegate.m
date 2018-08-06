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
    
    UIButton *button = [UIButton new];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.window addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.window);
        make.top.equalTo(self.window).offset(120);
    }];
    
    [button setTitle:@"eval" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(eval) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    
    return YES;
}

- (void)eval {
    [HotComplileEngine loadMainJs];
}

@end

/*
 2017.12 - now
 Working at China Mobile Communications Corporation of ChongQing
 position: Mobile App Engineer (iOS)
 duty: 1. Develop new modules for existing app
 2. Find and Repair existing bugs and refractor old code
 3. Code review for the other two iOS developers
 project:
 1. ChongQing City: https://itunes.apple.com/cn/app/%E9%87%8D%E5%BA%86%E5%9F%8E/id595252184?mt=8
 The architecture of the existing modules are MVC, which leads to massive controller, logical code couples with view module, network requests are placed in model parts, etc. I try to write new code in MVVM pattern, decouple model, view, logical, network from each other and ReactiveCocoa helps me much.
 
 2. Hedgehog
 A personal project which is still in developing state, but it has played a role in my daily coding. The direct reason for starting the project is that my company gave me an old machine, so that compiling always take a long time. Facilitated by the runtime ability of Objective-C, Hedgehog can help to load new modules while the program is runing which make developing much more effective.
 
 Working at Qimke Technology Co Ltd
 position: Mobile App Engineer (iOS); Venture partner;
 duty: 1. Totally in charge of app development on iphone
 2. Contribute all aspects of ideas and make them come true
 project:
 QiHua, recording your photos, path, mood during your traveling and the most import, you can collaberate with your partners.
 1. Adopting Swift as programming language.
 2. To deal with the large project and complex logic, MVVM was sticked. Compared with RxSwift to realize Responsive programming.
 3. Too much markers on map causes much pressure to GPU which leads to unsmooth view movement. To solve the problem, I use CoreGraphic to draw the markers on the background thread.
 
 
 
 */
