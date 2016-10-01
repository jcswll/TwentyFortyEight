//
//  TFETestHeader.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 3/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#ifndef TFETestHeader_h
#define TFETestHeader_h

@class TFENode;
@class TFEMove;

/**
 * Returns the indexes for the grid line furthest in the given direction;
 * these are the squares where spawning is not allowed after a move has
 * been made.
 */
NSIndexSet * TFEDisallowedSquaresByDirection(TFENodeDirection d);

/** Returns an NSMutableArray of 16 NSNull. */
NSMutableArray * TFENullArray(void);

/** Returns the indexes in squares that do not contain NSNull. */
NSIndexSet * TFEIndexesOfUnoccupiedSquares(NSArray * squares);

/**
 * Given a list of nodes, attempt to "slide" them towards the front of the
 * list, combining adjacent equal-valued nodes, and moving nodes through
 * empty spaces.
 *
 * Returns the reconfigured row, or nil if nothing actually moved.
 */
NSArray * TFESlideRow(NSArray * row);

/**
 * Does the actual work for the public function
 * TFESpawnNewNodeExcludingDirection(), which will pass in the result of
 * TFEDisallowedSquaresByDirection() for disallowedIndexes
 */
NSArray * TFESpawnNewNode(NSArray * grid,
                          NSIndexSet * disallowedIndexes,
                          TFEMove ** spawn);

/**
 * Returns a TFEMove describing a node's movement: the node,
 * the destination square, whether the node is being combined with another,
 * or whether the move is a spawn.
 */
TFEMove * TFEMoveDescription(TFENode * node, NSUInteger destination,
                             BOOL isCombo, BOOL isSpawn);


#endif /* TFETestHeader_h */
