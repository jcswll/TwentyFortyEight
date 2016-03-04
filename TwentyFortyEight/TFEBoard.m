
#import "TFEBoard.h"
#import "TFE.h"
#import "TFENode.h"
#import "TFEMove.h"
#import "TFEMainScene.h"

@interface TFEBoard ()

/** Grab the appropriate values from the spawn dictionary
 *  (created by TFEMoveDescription()) and pass the node and location info on to
 *  the scene for animating.
 */
- (void)executeSpawn:(TFEMove *)spawn;
/** Iterate the moves array, getting the values from each dictionary
 *  (created by TFEMoveDescription() add pass each node's new location info on
 *  to the scene for animating.
 */
- (void)executeMoves:(NSArray<TFEMove *> *)moves;

/** Test the board for win and loss conditions, notifying the scene if either
 *  is found.
 */
- (void)checkForEndGame;

@end

@implementation TFEBoard
{
    NSArray * _grid;
}

+ (instancetype)boardWithScene:(TFEMainScene *)scene
{
    return [[self alloc] initWithScene:scene];
}

- (instancetype)initWithScene:(TFEMainScene *)scene
{
    self = [super init];
    if( !self ) return nil;
    
    NSArray<TFEMove *> * initialSpawns;
    _grid = TFEBuildGrid(&initialSpawns);
    
    _scene = scene;
    
    for( TFEMove * spawn in initialSpawns ){
        [self executeSpawn:spawn];
    }
    
    return self;
}

- (void)moveNodesInDirection:(TFENodeDirection)direction
{
    NSArray<TFEMove *> * moves = nil;
    _grid = TFEMoveNodesInDirection(_grid, direction, &moves);
    
    if( !moves ) return;
        
    [self executeMoves:moves];
    
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
            continue;
        }
        
        [[self scene] moveNode:[move node]
                  toGridSquare:[move destination]
                     combining:[move isCombination]];
    }
}

- (void)checkForEndGame
{
    if( TFEIsAWinner(_grid) ){
        [[self scene] gameDidEndInVictory:YES];
    }
    else if( TFEIsALoser(_grid) ){
        [[self scene] gameDidEndInVictory:NO];
    }
}

@end
