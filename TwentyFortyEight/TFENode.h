//
//  TFENode.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TFENode : SKSpriteNode

/** Create a node with a standard size and the given value. */
+ (instancetype)nodeWithValue:(uint32_t)value;

/** The TFENode class tracks whether any instances are running their "move" or
 *  "spawn" animations in order to avoid overlapping creation and destruction
 *  of moving nodes. +waitOnAllNodeMovement blocks when called until all
 *  nodes have completed their animations.
 */
+ (void)waitOnAllNodeMovement;

/** The TFENode class tracks whether any instances are running their "move" or
 *  "spawn" animations. +anyNodeMovementInProgress returns immediately with a
 *  BOOL indicating whether any animations are currently running.
 */
+ (BOOL)anyNodeMovementInProgress;

/** The node's point value. This is a TFENode's sole feature for purposes
 *  of comparison to other nodes.
 */
@property (nonatomic) uint32_t value;

/** Perform an "appear" animation at the given position. 
 *  This is included in the class's register of node movement (see
 *  (+waitOnAllNodeMovement and +anyNodeMovementInProgress).
 */
- (void)spawnAtPosition:(CGPoint)position;
/** Perform a sliding animation to the given position.
 *  This is included in the class's register of node movement (see
 *  (+waitOnAllNodeMovement and +anyNodeMovementInProgress).
 */
- (void)moveToPosition:(CGPoint)destination;

/** Perform a slide and "disappear" animation to the given position.
 *  This is included in the class's register of node movement (see
 *  (+waitOnAllNodeMovement and +anyNodeMovementInProgress).
 */
- (void)moveIntoCombinationAtPosition:(CGPoint)destination;

@end
