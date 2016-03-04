//
//  TFEMainScene.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TFENode;
@class TFEBoard;

@interface TFEMainScene : SKScene

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

/** Animate a message for the end of the game. */
- (void)gameDidEndInVictory:(BOOL)victorious;

@end