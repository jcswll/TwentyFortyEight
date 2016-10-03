//
//  TFE.h
//  TFE
//
//  Created by Joshua Caswell on 3/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import Foundation;

#import "TFENodeDirection.h"

@class TFEMove;

/** 
 * Construct and return an initial grid, with two spawned nodes.
 * 
 * Returns spawn information indirectly.
 */
NSArray * TFEBuildGrid(NSArray<TFEMove *> ** spawns);

/** 
 * Attempt to slide all nodes in grid towards the given direction.
 *  
 * If any nodes actually move, indirectly returns an NSArray of TFEMove
 * objects describing the movement. If no movement took place, the array
 * will be nil.
 *
 * Returns the grid as reconfigured after all movement has taken place.
 */
NSArray * TFEMoveNodesInDirection(NSArray * grid,
                                  TFENodeDirection direction,
                                  NSArray<TFEMove *> ** moves);

/** 
 * Create a new node at a random index selected from those that are both
 * unoccupied and not in the line furthest in the disallowed direction.
 * The node has value 2 or 4, chosen at random.
 * 
 * Indirectly returns a TFEMove object describing the spawn.
 * 
 * Returns the grid with the new node added.
 */
NSArray * TFESpawnNewNodeExcludingDirection(NSArray * grid,
                                            TFENodeDirection direction,
                                            TFEMove ** spawn);

/** Returns YES if the grid contains the winning-valued node. */
BOOL TFEIsAWinner(NSArray * grid);

/** Returns YES if the grid is full and no moves are possible. */
BOOL TFEIsALoser(NSArray * grid);


/** 
 * Returns the points scored for the moves in the list: combinations score
 * the value of each of their components.
 */
uint32_t TFEScoreForMoves(NSArray<TFEMove *> * moves);
