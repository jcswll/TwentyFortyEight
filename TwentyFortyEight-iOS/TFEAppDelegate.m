//
//  TFEAppDelegate.m
//  TwentyFortyEight-iOS
//
//  Created by Joshua Caswell on 9/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEAppDelegate.h"

#import "TFEGameController.h"

@interface TFEAppDelegate ()

@end

@implementation TFEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow * window = [UIWindow new];
    TFEGameController * controller = [TFEGameController new];
    
    [self setMainWindow:window];
    [window setRootViewController:controller];
    
    [window makeKeyAndVisible];
    
    return YES;
}

@end
