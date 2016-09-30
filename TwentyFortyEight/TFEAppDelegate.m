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
    TFEMainScene * scene = [[TFEMainScene alloc] initWithSize:[[self mainView] frame].size];
    TFEGameController * controller = [TFEGameController controllerForScene:scene];
    [self setGameController:controller];
    [controller setScoreLabel:[self scoreLabel]];
    
    [[self mainWindow] makeFirstResponder:controller];
    
    [[self mainView] presentScene:scene];
}

@end
