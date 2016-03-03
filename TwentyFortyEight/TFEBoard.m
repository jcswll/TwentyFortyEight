
#import "TFEBoard.h"
#import "TFENode.h"
#import "TFEMainScene.h"
#import "NSArray+TFEFunctional.h"
#import "NSIndexSet+TFEHelpers.h"

@interface TFEBoard ()

- (NSIndexSet *)disallowedSquaresByDirection:(TFENodeDirection)d;
- (NSIndexSet *)indexesOfUnoccupiedSquares;

- (void)spawnNewNodeExcludingIndexes:(NSIndexSet *)disallowedIndexes;

/** Given a list of nodes, attempts to "slide" them towards the front of the 
 *  list, combining adjacent equal-valued nodes, and moving nodes through 
 *  empty spaces. 
 *  Returns the reconfigured row, or nil if nothing actually moved.
 */
- (NSArray *)slideNodes:(NSArray *)nodes;

@end

NSMutableArray * fakeGrid(uint32_t val, ...);
NSMutableArray * nullArray(void);

@implementation TFEBoard
{
    NSArray * _grid;
}

static const NSUInteger gridLinesByDirection[4][4][4] =
        {{{0, 1, 2, 3}, {4, 5, 6, 7}, {8, 9, 10, 11}, {12, 13, 14, 15}},
         {{12, 8, 4, 0}, {13, 9, 5, 1}, {14, 10, 6, 2}, {15, 11, 7, 3}},
         {{3, 2, 1, 0}, {7, 6, 5, 4}, {11, 10, 9, 8}, {15, 14, 13, 12}},
         {{0, 4, 8, 12}, {1, 5, 9, 13}, {2, 6, 10, 14}, {3, 7, 11, 15}}};

- (BOOL)moveNodesInDirection:(TFENodeDirection)direction
{
    BOOL somethingDidMove = NO;
    NSMutableArray * newGrid = nullArray();
    
    for( int row_i = 0; row_i < 4; row_i++ ){
        
        // Grab nodes for row
        NSMutableArray * rowNodes = [NSMutableArray array];
        for( int i = 0; i < 4; i++ ){
            NSUInteger idx = gridLinesByDirection[direction][row_i][i];
            [rowNodes addObject:_grid[idx]];
        }
        
        BOOL rowDidMove = YES;
        NSArray * slidNodes = [self slideNodes:rowNodes];
        if( !slidNodes ){
            rowDidMove = NO;
            slidNodes = rowNodes;
        }
        somethingDidMove = rowDidMove || somethingDidMove;
        
        [slidNodes enumerateObjectsUsingBlock:
         ^(id element, NSUInteger idx, BOOL * stop)
         {
             NSUInteger destSquare = gridLinesByDirection[direction][row_i][idx];
             if( [element isKindOfClass:[NSArray class]] ){
                 for( TFENode * node in element ){
                     [[self scene] moveNode:node
                               toGridSquare:destSquare
                                  combining:YES];
                 }
                 
                 uint32_t newVal = [(TFENode*)element[0] value] * 2;
                 TFENode * combinedNode = [TFENode nodeWithValue:newVal];
                 newGrid[destSquare] = combinedNode;
                 [[self scene] spawnNode:combinedNode
                                inSquare:destSquare];
             }
             else {
                 newGrid[destSquare] = element;
                 if( rowDidMove ){
                     [[self scene] moveNode:element
                               toGridSquare:destSquare
                                  combining:NO];
                 }
             }
         }];
    }
    
    _grid = newGrid;
    
    if( somethingDidMove ){
        [self spawnNewNodeExcludingIndexes:
                               [self disallowedSquaresByDirection:direction]];
    }
    
    return somethingDidMove;
}


- (NSIndexSet *)disallowedSquaresByDirection:(TFENodeDirection)d
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

- (NSIndexSet *)indexesOfUnoccupiedSquares
{
    return [_grid indexesOfObjectsPassingTest:
            ^BOOL (id obj, NSUInteger idx, BOOL * stop)
            {
                return obj == [NSNull null];
            }];
}

NSMutableArray * nullArray(void)
{
    NSMutableArray * grid = [NSMutableArray array];
    for( int i = 0; i < 16; i++ ){
        grid[i] = [NSNull null];
    }
    
    return grid;
}

- (void)buildGrid
{
    _grid = nullArray();
    
    [self spawnNewNodeExcludingIndexes:nil];
    [self spawnNewNodeExcludingIndexes:nil];
}

- (void)spawnNewNodeExcludingIndexes:(NSIndexSet *)disallowedIndexes
{
    NSMutableIndexSet * unoccupiedSquares =
        [[self indexesOfUnoccupiedSquares] mutableCopy];
    if( disallowedIndexes ){
        [unoccupiedSquares removeIndexes:disallowedIndexes];
    }
    
    uint32_t val = (arc4random_uniform(2) + 1) * 2;
    NSUInteger idx = [unoccupiedSquares TFERandomIndex];
    TFENode * node = [TFENode nodeWithValue:val];
    NSMutableArray * newNodes = [_grid mutableCopy];
    [newNodes replaceObjectAtIndex:idx
                        withObject:node];
    [[self scene] spawnNode:node inSquare:idx];
    
    _grid = newNodes;
}

- (NSArray *)slideNodes:(NSArray *)nodes
{
    NSArray * realNodes = [nodes filteredArrayUsingPredicate:
                            [NSPredicate predicateWithFormat:@"self != nil"]];
    if( [realNodes count] == 0 ){
        return nil;
    }
    
    TFEFolder slider =
        ^NSMutableArray * (NSMutableArray * accum, TFENode * node)
        {
            id newVal = node;
            id lastVal = [accum lastObject];
            // lastVal is either NSArray of two nodes, or a node
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
    BOOL didMove = ![nodes isEqualToArray:reconstructedRow];
    return didMove ? slidRow : nil;
}

- (void)checkForEndGame
{
    static TFENode * twentyFortyEight;
    if( !twentyFortyEight ){
        twentyFortyEight = [TFENode nodeWithValue:2048];
    }
    
    if( [_grid containsObject:twentyFortyEight] ){
        [[self scene] gameDidEndInVictory:YES];
    }
    else if( [[self indexesOfUnoccupiedSquares] count] == 0 ){
        // FIXME: Dirty, filthy hacks requiring redesign of moveNodesInDirection:
        NSArray * savedGrid = [_grid copy];
        TFEMainScene * savedScene = [self scene];
        [self setScene:nil];
        BOOL canMove = NO;
        for( TFENodeDirection d = 0; d < 4; d++ ){
            canMove = [self moveNodesInDirection:d];
            if( canMove ){
                break;
            }
        }
        [self setScene:savedScene];
        _grid = savedGrid;
        if( !canMove ){
            [[self scene] gameDidEndInVictory:NO];
        }
    }
}

@end

#pragma mark - Debug functions

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

void drawGrid(NSArray * squares)
{
    for( int row = 0; row < 4; row++ ){
        for( int col = 0; col < 4; col++ ){
            NSUInteger idx = (row * 4) + col;
            id elem = squares[idx];
            NSString * desc;
            if( elem == [NSNull null] ){
                desc = @" __ ";
            }
            else {
                desc = [NSString stringWithFormat:@" %2d ", [(TFENode*)elem value]];
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
