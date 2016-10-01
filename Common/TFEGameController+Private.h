//
//  TFEGameController+Private.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/30/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import SpriteKit;

#import "TFEGameController.h"

@class TFEBoard;
@class TFEMainScene;

@interface TFEGameController ()

@property (strong, nonatomic) TFEMainScene * scene;
@property (strong, nonatomic) TFEBoard * board;

@end
