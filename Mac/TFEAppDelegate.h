//
//  TFEAppDelegate.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import Cocoa;
@import SpriteKit;

@class TFELabel;
@class TFEGameController;

@interface TFEAppDelegate : NSObject <NSApplicationDelegate>

@property (weak, nonatomic) IBOutlet NSWindow * mainWindow;

@property (strong, nonatomic) TFEGameController * gameController;

@end
