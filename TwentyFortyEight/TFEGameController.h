//
//  TFEGameController.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import Cocoa;

@class TFEMainScene;
@class TFELabel;

@interface TFEGameController : NSResponder

+ (instancetype)controllerForScene:(TFEMainScene *)scene;

@property (weak, nonatomic) TFELabel * scoreLabel;

@end

@interface TFEGameController (TFEBoardUpdates)

/** Animate a message for the end of the game. */
- (void)gameDidEndInVictory:(BOOL)victorious;

- (void)updateScoreTo:(uint32_t)new_score;

@end
