
#import "TFEBoard.h"
#import "TFE.h"
#import "TFENode.h"
#import "TFEMainScene.h"

@interface TFEBoard ()

/** Grab the appropriate values from the spawn dictionary
 *  (created by TFEMoveDescription()) and pass the node and location info on to
 *  the scene for animating.
 */
- (void)executeSpawn:(NSDictionary *)spawn;
/** Iterate the moves array, getting the values from each dictionary
 *  (created by TFEMoveDescription() add pass each node's new location info on
 *  to the scene for animating.
 */
- (void)executeMoves:(NSArray<NSDictionary *> *)moves;

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
    
    NSArray * initialSpawns;
    _grid = TFEBuildGrid(&initialSpawns);
    
    _scene = scene;
    
    for( NSDictionary * spawn in initialSpawns ){
        [self executeSpawn:spawn];
    }
    
    return self;
}

- (void)moveNodesInDirection:(TFENodeDirection)direction
{
    NSArray * moves = nil;
    _grid = TFEMoveNodesInDirection(_grid, direction, &moves);
    
    if( !moves ) return;
        
    [self executeMoves:moves];
    
    NSDictionary * spawn = nil;
    _grid = TFESpawnNewNodeExcludingDirection(_grid, direction, &spawn);
    [self executeSpawn:spawn];
    
    [self checkForEndGame];
}

- (void)executeSpawn:(NSDictionary *)spawn
{
    TFENode * node = spawn[kTFENodeKey];
    NSUInteger destSquare = [spawn[kTFEMoveKey] unsignedIntegerValue];
    
    [[self scene] spawnNode:node inSquare:destSquare];
}

- (void)executeMoves:(NSArray *)moves
{
    for( NSDictionary * move in moves ){
        if( [move[kTFEMoveIsSpawnKey] boolValue] ){
            [self executeSpawn:move];
            continue;
        }
        
        TFENode * node = move[kTFENodeKey];
        NSUInteger destSquare = [move[kTFEMoveKey] unsignedIntegerValue];
        BOOL isCombo = [move[kTFEMoveIsComboKey] boolValue];
        
        [[self scene] moveNode:node
                  toGridSquare:destSquare
                     combining:isCombo];
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
