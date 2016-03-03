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

- (void)moveNode:(TFENode *)node
    toGridSquare:(NSUInteger)square
       combining:(BOOL)combining;

- (void)spawnNode:(TFENode *)node inSquare:(NSUInteger)square;

- (void)gameDidEndInVictory:(BOOL)victorious;

@end