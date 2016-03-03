//
//  TFEBoard.h
//  TFE
//
//  Created by Joshua Caswell on 3/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFENodeDirection.h"

@class TFEMainScene;

/** TFEBoard represents the playing field and is responsible for all the
 *  operations that take place on it: moving, combining, spawning, and
 *  destroying nodes, as well as checking for winning/losing conditions.
 */
@interface TFEBoard : NSObject

+ (instancetype)boardWithScene:(TFEMainScene *)scene;

/** Reference to the scene which displays the nodes that are managed by the
 *  board. The board tells the scene about nodes that move.
 */
@property (weak, nonatomic) TFEMainScene * scene;

/** Attempt to slide all nodes in the given direction. 
 *  The scene will be notified if any movement actually takes place.
 */
- (void)moveNodesInDirection:(TFENodeDirection)direction;

@end
