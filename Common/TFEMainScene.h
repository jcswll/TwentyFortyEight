//
//  TFEMainScene.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TFENode;

@interface TFEMainScene : SKScene

/** Returns YES while noode movement is taking place, so that, e.g. user input can be rejected. */
- (BOOL)anyMovementInProgress;

@end

@interface TFEMainScene (TFEBoardCommunication)

/** Animate node to the correct position for the index square, destroying
 *  the node if combining is true.
 */
- (void)moveNode:(TFENode *)node
    toGridSquare:(NSUInteger)square
       combining:(BOOL)combining;

/** Animate the appearance of node at the position for the index square. */
- (void)spawnNode:(TFENode *)node inSquare:(NSUInteger)square;

- (void)gameDidEndInVictory:(BOOL)victorious;

@end
