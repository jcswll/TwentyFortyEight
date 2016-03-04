//
//  TFE.h
//  TFE
//
//  Created by Joshua Caswell on 3/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFENodeDirection.h"

extern NSString * const kTFENodeKey;
extern NSString * const kTFEMoveKey;
extern NSString * const kTFEMoveIsSpawnKey;
extern NSString * const kTFEMoveIsComboKey;

/** Constructs and returns an initial grid, with two spawned nodes. 
 *  Returns spawn information indirectly.
 */
NSArray * TFEBuildGrid(NSArray<NSDictionary *> ** spawns);

/** Attempt to slide all nodes in grid towards the given direction. 
 *  
 *  If any nodes actually move, indirectly returns an NSArray of dictionaries
 *  describing the nodes and their new squares, keyed by kTFENodeKey and 
 *  kTFEMoveKey respectively, as well as an NSNumber under kTFEMoveIsComboKey,
 *  whose boolValue indicates
 *  whether the move is a combination or not.
 *  If no movement took place, the array will be nil.
 *
 *  Returns the grid as reconfigured after all movement has taken place.
 */
NSArray * TFEMoveNodesInDirection(NSArray * grid,
                               TFENodeDirection direction,
                               NSArray<NSDictionary *> ** moves);

/** Creates a new node at a random index selected from those that are both
 *  unoccupied and not in the line furthest in the disallowed direction. 
 *  The node has value 2 or 4, chosen at random. 
 *  Indirectly returns a dictionary with the new node and the index of its
 *  grid square, keyed by kTFENodeKey and kTFEMoveKey respectively.
 *  Returns the grid with the new node added.
 */
NSArray * TFESpawnNewNodeExcludingDirection(NSArray * grid,
                                         TFENodeDirection direction,
                                         NSDictionary ** spawn);

/** Returns YES if the grid contains the winning-valued node. */
BOOL TFEIsAWinner(NSArray * grid);

/** Returns YES if the grid is full and no moves are possible. */
BOOL TFEIsALoser(NSArray * grid);
