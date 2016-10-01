//
//  TFEAppDelegate.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEAppDelegate.h"
#import "TFEMainScene.h"
#import "TFEGameController.h"

@implementation TFEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    TFEGameController * controller = [TFEGameController new];
    [self setGameController:controller];
    
    [[self mainWindow] setContentViewController:controller];
    [[self mainWindow] makeFirstResponder:controller];
    
    [[self mainWindow] makeKeyAndOrderFront:self];
}

@end
