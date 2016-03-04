
#import "TFE.h"
#import "TFENode.h"
#import "NSArray+TFEFunctional.h"
#import "NSIndexSet+TFEHelpers.h"

NSString * const kTFENodeKey = @"TFENode";
NSString * const kTFEMoveKey = @"TFEMove";
NSString * const kTFEMoveIsSpawnKey = @"TFEMoveIsSpawn";
NSString * const kTFEMoveIsComboKey = @"TFEMoveIsCombo";

#pragma mark - Private function decls

/** Returns the indexes for the grid line furthest in the given direction; 
 *  these are the squares where spawning is not allowed after a move has 
 *  been made.
 */
NSIndexSet * TFEDisallowedSquaresByDirection(TFENodeDirection d);
/** Returns an NSMutableArray of 16 NSNull. */
NSMutableArray * TFENullArray(void);
/** Returns the indexes in squares that do not contain NSNull. */
NSIndexSet * TFEIndexesOfUnoccupiedSquares(NSArray * squares);
/** Given a list of nodes, attempts to "slide" them towards the front of the
 *  list, combining adjacent equal-valued nodes, and moving nodes through
 *  empty spaces.
 *  Removes nulls before sliding.
 *  Returns the reconfigured row, or nil if nothing actually moved.
 */
NSArray * TFESlideRow(NSArray * row);

/** Does the actual work for the public function 
 *  TFESpawnNewNodeExcludingDirection(), which will pass in the result of
 *  TFEDisallowedSquaresByDirection()
 */
NSArray * TFESpawnNewNode(NSArray * grid,
                       NSIndexSet * disallowedIndexes,
                       NSDictionary ** spawn);

/** Returns a dictionary describing a node's movement: the node,
 *  the destination square, whether the node is being combined with another,
 *  or whether the move is a spawn.
 */
NSDictionary * TFEMoveDescription(TFENode * node, NSUInteger destination,
                               BOOL isCombo, BOOL isSpawn);

#pragma mark - Public fuctions

NSArray * TFEBuildGrid(NSArray **spawns)
{
    NSArray * grid = (NSArray *)TFENullArray();
    
    NSDictionary * firstSpawn;
    NSDictionary * secondSpawn;
    grid = TFESpawnNewNode(grid, nil, &firstSpawn);
    grid = TFESpawnNewNode(grid, nil, &secondSpawn);
    
    *spawns = @[firstSpawn, secondSpawn];
    
    return grid;
}

static const NSUInteger gridLinesByDirection[4][4][4] =
    {{{0, 1, 2, 3}, {4, 5, 6, 7}, {8, 9, 10, 11}, {12, 13, 14, 15}},
     {{12, 8, 4, 0}, {13, 9, 5, 1}, {14, 10, 6, 2}, {15, 11, 7, 3}},
     {{3, 2, 1, 0}, {7, 6, 5, 4}, {11, 10, 9, 8}, {15, 14, 13, 12}},
     {{0, 4, 8, 12}, {1, 5, 9, 13}, {2, 6, 10, 14}, {3, 7, 11, 15}}};

NSArray * TFEMoveNodesInDirection(NSArray * grid,
                               TFENodeDirection direction,
                               NSArray ** moves)
{
    NSMutableArray * newGrid = TFENullArray();
    NSMutableArray * newMoves = nil;
    
    for( int row_i = 0; row_i < 4; row_i++ ){
        
        // Grab nodes for row and clear out square master list
        // Can't do this with an index set because they need to be in reverse
        // order when moving in two of the four directions.
        NSMutableArray * rowNodes = [NSMutableArray array];
        for( int i = 0; i < 4; i++ ){
            NSUInteger idx = gridLinesByDirection[direction][row_i][i];
            rowNodes[i] = grid[idx];
        }
        
        NSArray * slidRow = TFESlideRow(rowNodes);
        // No movement, just copy over nodes and move to the next row.
        if( !slidRow ){
            for( int i = 0; i < 4; i++ ){
                NSUInteger idx = gridLinesByDirection[direction][row_i][i];
                newGrid[idx] = grid[idx];
            }
            continue;
        }
        
        newMoves = newMoves ?: [NSMutableArray array];
        [slidRow enumerateObjectsUsingBlock:
             ^(id element, NSUInteger idx, BOOL * stop)
             {
                 NSUInteger destSquare =
                                  gridLinesByDirection[direction][row_i][idx];
                 if( [element isKindOfClass:[NSArray class]] ){
                     for( TFENode * node in element ){
                         [newMoves addObject:
                                TFEMoveDescription(node, destSquare, YES, NO)];
                     }
                     uint32_t newVal = [(TFENode*)element[0] value] * 2;
                     TFENode * combinedNode = [TFENode nodeWithValue:newVal];
                     newGrid[destSquare] = combinedNode;
                     [newMoves addObject:
                        TFEMoveDescription(combinedNode, destSquare, NO, YES)];
                 }
                 else {
                     newGrid[destSquare] = element;
                     [newMoves addObject:
                        TFEMoveDescription(element, destSquare, NO, NO)];
                 }
             }];
    }
    
    // Still nil if no moves were made
    *moves = newMoves;
    return newGrid;
}

NSArray * TFESpawnNewNodeExcludingDirection(NSArray * grid,
                                         TFENodeDirection direction,
                                         NSDictionary ** spawn)
{
    return TFESpawnNewNode(grid, TFEDisallowedSquaresByDirection(direction), spawn);
}



BOOL TFEIsAWinner(NSArray * grid)
{
    static TFENode * twentyFortyEight;
    if( !twentyFortyEight ){
        twentyFortyEight = [TFENode nodeWithValue:2048];
    }
    
    return [grid containsObject:twentyFortyEight];
}

BOOL TFEIsALoser(NSArray * grid)
{
    // If the board is not full, can't have lost yet
    if( [TFEIndexesOfUnoccupiedSquares(grid) count] > 0 ){
        return NO;
    }
    
    // Check movement in all directions.
    NSArray * moves = nil;
    for( TFENodeDirection d = 0; d < 4; d++ ){
        id __unused _ = TFEMoveNodesInDirection(grid, d, &moves);
        // If movement is possible in _any_ direction, haven't lost.
        if( moves ){
            break;
        }
    }
    
    return (moves == nil);
}

#pragma mark - Private functions

NSIndexSet * TFEDisallowedSquaresByDirection(TFENodeDirection d)
{
    static const NSUInteger left[4] = {12, 8, 4, 0};
    static NSIndexSet * leftSet;
    if( !leftSet ){
        leftSet = [NSIndexSet TFEIndexSetWithIntegers:left count:4];
    }
    static const NSUInteger up[4] = {12, 13, 14, 15};
    static NSIndexSet * upSet;
    if( !upSet ){
        upSet = [NSIndexSet TFEIndexSetWithIntegers:up count:4];
    }
    static const NSUInteger right[4] = {15, 11, 7, 3};
    static NSIndexSet * rightSet;
    if( !rightSet ){
        rightSet = [NSIndexSet TFEIndexSetWithIntegers:right count:4];
    }
    static const NSUInteger down[4] = {0, 1, 2, 3};
    static NSIndexSet * downSet;
    if( !downSet ){
        downSet = [NSIndexSet TFEIndexSetWithIntegers:down count:4];
    }
    
    static NSArray * list;
    if( !list ){
        list = @[leftSet, upSet, rightSet, downSet];
    }
    
    return list[d];
}

NSMutableArray * TFENullArray(void)
{
    NSMutableArray * grid = [NSMutableArray array];
    for( int i = 0; i < 16; i++ ){
        grid[i] = [NSNull null];
    }
    
    return grid;
}

NSIndexSet * TFEIndexesOfUnoccupiedSquares(NSArray * grid)
{
    return [grid indexesOfObjectsPassingTest:
                ^BOOL (id obj, NSUInteger idx, BOOL * stop)
                  {
                      return obj == [NSNull null];
                  }];
}

NSArray * TFESlideRow(NSArray * row)
{
    NSArray * realNodes = [row filteredArrayUsingPredicate:
                            [NSPredicate predicateWithFormat:@"self != nil"]];
    if( [realNodes count] == 0 ){
        return nil;
    }
    
    TFEFolder slider =
        ^NSMutableArray * (NSMutableArray * accum, TFENode * node)
        {
            id newVal = node;
            id lastVal = [accum lastObject];
            // lastVal is either NSArray of two nodes or a node
            // If it's a node, and equal, combine them into an NSArray
            // for further processing
            if( [lastVal isEqual:node] ){
                 [accum removeLastObject];
                 newVal = @[lastVal, node];
             }

             // Otherwise just add the new node to the result
             [accum addObject:newVal];
             return accum;
        };
    
    NSMutableArray * initial = [NSMutableArray arrayWithObject:realNodes[0]];
    NSArray * slidRow = [[realNodes TFETail] TFEFoldWithInitial:initial
                                                    usingFolder:slider];
    // slidRow must have at least one object in it.
    // Adding three nulls and then cutting off at four is easier than
    // counting and constructing a new mutable array again.
    NSArray * reconstructedRow =
        [[slidRow arrayByAddingObjectsFromArray:
                                @[[NSNull null], [NSNull null], [NSNull null]]]
            subarrayWithRange:(NSRange){0,4}];
    BOOL didMove = ![row isEqualToArray:reconstructedRow];
    return didMove ? slidRow : nil;
}

NSArray * TFESpawnNewNode(NSArray * grid,
                       NSIndexSet * disallowedIndexes,
                       NSDictionary ** spawn)
{
    NSMutableIndexSet * unoccupiedSquares =
                    [TFEIndexesOfUnoccupiedSquares(grid) mutableCopy];
    if( disallowedIndexes ){
        [unoccupiedSquares removeIndexes:disallowedIndexes];
    }
    
    NSUInteger idx = [unoccupiedSquares TFERandomIndex];
    
    // Bias heavily towards new value being a 2
    uint32_t draw = arc4random_uniform(10);
    uint32_t val = (draw < 9) ? 2 : 4;
    TFENode * node = [TFENode nodeWithValue:val];
    
    NSMutableArray * newGrid = [grid mutableCopy];
    [newGrid replaceObjectAtIndex:idx
                       withObject:node];
    
    *spawn = TFEMoveDescription(node, idx, NO, YES);
    
    return newGrid;
}
         
NSDictionary * TFEMoveDescription(TFENode * node, NSUInteger destination,
                                  BOOL isCombo, BOOL isSpawn)
{
    return @{kTFENodeKey : node,
             kTFEMoveKey : @(destination),
             kTFEMoveIsComboKey : @(isCombo),
             kTFEMoveIsSpawnKey : @(isSpawn)};
}

#pragma mark - Debug functions

char * center_string(const char * s, int width);
void drawGrid(NSArray * grid);
NSMutableArray * fakeGrid(uint32_t v, ...);

char * center_string(const char * s, int width)
{
    int len = (int)strlen(s);
    int pad_half_len = (width - len) / 2;
    char * r = calloc(7, sizeof(char));
    for( int i = 0; i < pad_half_len; i++ ){
        r = strcat(r, " ");
    }
    r = strcat(r, s);
    for( int i = 0; i < pad_half_len; i++ ){
        r = strcat(r, " ");
    }
    
    return r;
}

void drawGrid(NSArray * grid)
{
    for( int row = 0; row < 4; row++ ){
        for( int col = 0; col < 4; col++ ){
            NSUInteger idx = (row * 4) + col;
            id elem = grid[idx];
            NSString * desc;
            if( elem == [NSNull null] ){
                desc = @" __ ";
            }
            else {
                desc = [NSString stringWithFormat:@" %2d ",
                                                  [(TFENode*)elem value]];
            }
            printf("%s", center_string([desc UTF8String], 6));
        }
        printf("\n");
    }
    printf("\n");
}

NSMutableArray * fakeGrid(uint32_t v, ...)
{
    NSMutableArray * grid = [NSMutableArray array];
    va_list args;
    va_start(args, v);
    uint32_t value = v;
    while( value != UINT32_MAX ){
        id new = [NSNull null];
        if( value != 0 ){
            new = [TFENode nodeWithValue:value];
        }
        [grid addObject:new];
        value = va_arg(args, uint32_t);
    }
    va_end(args);
    
    return grid;
}

