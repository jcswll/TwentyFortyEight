//
//  TFEMainScene.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import SpriteKit;

@class TFENode;

@interface TFEMainScene : SKScene

/** Returns NO while node movement is taking place. */
- (BOOL)canAcceptInput;

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
