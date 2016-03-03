//
//  TFEBoard.h
//  TFE
//
//  Created by Joshua Caswell on 3/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TFENodeDirection) {
    TFENodeDirectionLeft = 0,
    TFENodeDirectionUp,
    TFENodeDirectionRight,
    TFENodeDirectionDown,
    TFENodeDirectionNotADirection
};

@class TFEMainScene;

/** TFEBoard represents the playing field and is responsible for all the
 *  operations that take place on it: moving, combining, spawning, and
 *  destroying nodes, as well as checking for winning/losing conditions.
 */
@interface TFEBoard : NSObject

/** Reference to the scene which displays the nodes that are managed by the
 *  board. The board tells the scene about nodes that move.
 */
@property (weak, nonatomic) TFEMainScene * scene;

- (void)buildGrid;

/** Attempt to slide all nodes in the given direction. Returns YES
 *  if any nodes actually move, NO otherwise;
 */
- (BOOL)moveNodesInDirection:(TFENodeDirection)direction;

- (void)checkForEndGame;

@end
