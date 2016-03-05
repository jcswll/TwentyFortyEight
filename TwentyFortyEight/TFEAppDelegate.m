//
//  TFEAppDelegate.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEAppDelegate.h"
#import "TFEMainScene.h"

@implementation TFEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[self mainWindow] setContentAspectRatio:(NSSize){1, 1}];
    
    TFEMainScene *scene = [[TFEMainScene alloc] initWithSize:[[self mainView] frame].size];
    
    [[self mainView] presentScene:scene];
}

@end
