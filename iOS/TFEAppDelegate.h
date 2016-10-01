//
//  TFEAppDelegate.h
//  TwentyFortyEight-iOS
//
//  Created by Joshua Caswell on 9/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import UIKit;
@import SpriteKit;

@class TFELabel;
@class TFEGameController;

@interface TFEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * mainWindow;

@property (weak, nonatomic) IBOutlet SKView * mainView;
@property (weak, nonatomic) IBOutlet TFELabel * scoreLabel;

@property (strong, nonatomic) TFEGameController * gameController;

@end
