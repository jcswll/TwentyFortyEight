//  TFEBoard.h
//  TFE
//
//  Created by Joshua Caswell on 3/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.

#import "TwentyFortyEight-Swift.h"

#import "TFEBoard.h"
#import "TFE.h"
#import "TFENode.h"
#import "TFEMove.h"
#import "TFEMainScene.h"

@interface TFEBoard ()

/**
 * Reference to the controller that runs the overall game. The board tells it about score updates
 * and game end conditions.
 */
@property (weak, nonatomic) TFEGameController * controller;

/**
 * Reference to the scene which displays the nodes that are managed by the
 * board. The board tells the scene about nodes that move.
 */
@property (weak, nonatomic) TFEMainScene * scene;

/** 
 * Grab the appropriate values from the \c spawn object (created by
 * \c TFEMoveDescription() ) and pass the node and location info on to
 * the scene for animating.
 */
- (void)executeSpawn:(TFEMove *)spawn;
/** 
 * Get the values from each move in the \c moves array, (created by 
 * \c TFEMoveDescription() ) and pass each node's new location info on
 * to the scene for animating.
 */
- (void)executeMoves:(NSArray<TFEMove *> *)moves;

/** Add the score for each move in \c moves to the current score, and 
 *  notify the controller if any update is necessary.
 */
- (void)scoreMoves:(NSArray<TFEMove *> *)moves;

/** Test the board for win and loss conditions, notifying the controller if either
 *  is found.
 */
- (void)checkForEndGame;

@end

@implementation TFEBoard
{
    NSArray * _grid;
    uint32_t _score;
}

+ (instancetype)boardWithController:(TFEGameController *)controller
                              scene:(TFEMainScene *)scene
{
    return [[self alloc] initWithController:controller scene:scene];
}

- (instancetype)initWithController:(TFEGameController *)controller
                             scene:(TFEMainScene *)scene
{
    self = [super init];
    if( !self ) return nil;
    
    NSArray<TFEMove *> * initialSpawns;
    _grid = TFEBuildGrid(&initialSpawns);
    
    _controller = controller;
    _scene = scene;
    
    for( TFEMove * spawn in initialSpawns ){
        [self executeSpawn:spawn];
    }
    
    return self;
}

- (void)moveNodesInDirection:(TFENodeDirection)direction
{
    if( direction == TFENodeDirectionNotADirection ) {
        return;
    }
    
    NSArray<TFEMove *> * moves = nil;
    _grid = TFEMoveNodesInDirection(_grid, direction, &moves);
    
    if( !moves ) return;
        
    [self executeMoves:moves];
    
    [self scoreMoves:moves];
    
    TFEMove * spawn = nil;
    _grid = TFESpawnNewNodeExcludingDirection(_grid, direction, &spawn);
    [self executeSpawn:spawn];
    
    [self checkForEndGame];
}

- (void)executeSpawn:(TFEMove *)spawn
{
    [[self scene] spawnNode:[spawn node] inSquare:[spawn destination]];
}

- (void)executeMoves:(NSArray<TFEMove *> *)moves
{
    for( TFEMove * move in moves ){
        
        if( [move isSpawn] ){
            [self executeSpawn:move];
        }
        else {
            
            [[self scene] moveNode:[move node]
                      toGridSquare:[move destination]
                         combining:[move isCombination]];
        }
    }
}

- (void)scoreMoves:(NSArray<TFEMove *> *)moves
{
    uint32_t new_points = TFEScoreForMoves(moves);
    if( new_points > 0 ){
        _score += new_points;
        [[self controller] updateScoreTo:_score];
    }
}

- (void)checkForEndGame
{
    if( TFEIsAWinner(_grid) ){
        [[self controller] gameDidEndInVictory:YES];
    }
    else if( TFEIsALoser(_grid) ){
        [[self controller] gameDidEndInVictory:NO];
    }
}

@end
