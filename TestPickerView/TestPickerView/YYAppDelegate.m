//
//  YYAppDelegate.m
//  TestPickerView
//
//  Created by Ivan on 13-10-16.
//  Copyright (c) 2013年 灵感方舟. All rights reserved.
//

#import "YYAppDelegate.h"
#import "YYViewController.h"

@implementation YYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [YYViewController new];
    return YES;
}


@end
