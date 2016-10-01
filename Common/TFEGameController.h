//
//  TFEGameController.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import SpriteKit;

#import "TFEViewController.h"

@class TFEMainScene;
@class TFELabel;

@interface TFEGameController : TFEViewController

@property (weak, nonatomic) IBOutlet SKView * gameView;

@property (weak, nonatomic) IBOutlet TFELabel * scoreLabel;

@end

@interface TFEGameController (TFEBoardUpdates)

/** Animate a message for the end of the game. */
- (void)gameDidEndInVictory:(BOOL)victorious;

- (void)updateScoreTo:(uint32_t)new_score;

@end
