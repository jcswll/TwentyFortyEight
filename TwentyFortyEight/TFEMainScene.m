//
//  TFEMainScene.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEMainScene.h"
#import "TFENode.h"
#import "NSIndexSet+TFERandomIndex.h"
// Include Carbon header for key code enum
#import <Carbon/Carbon.h>

CGFloat vectorMagnitude(CGVector vector);

typedef NS_ENUM(NSUInteger, TFENodeDirection) {
    TFENodeDirectionLeft = 0,
    TFENodeDirectionUp,
    TFENodeDirectionRight,
    TFENodeDirectionDown,
    TFENodeDirectionNotOrthogonal
};

@interface TFEMainScene () <SKPhysicsContactDelegate>

/** Point for the center of the grid square at the given index. 0-based,
 * counting from bottom left.
 */
- (CGPoint)centerOfGridSquare:(NSUInteger)squareNumber;

@end

@implementation TFEMainScene
{
    NSMutableArray * allNodes;
    BOOL createdContent;
    BOOL nodesMoved;
}

- (void)didMoveToView:(SKView *)view
{
    if( createdContent ){
        return;
    }
    
    createdContent = YES;
    allNodes = [NSMutableArray array];
    for(int i = 0; i < 2; i++ ){
        NSUInteger startSquare = arc4random_uniform(16);
        TFENode * node = [TFENode nodeWithValue:2
                                       position:[self centerOfGridSquare:startSquare]];
        [allNodes addObject:node];
        [self addChild:node];
    }
    
    [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:[self frame]]];
    
    [[self physicsWorld] setContactDelegate:self];
}

static const CGFloat kImpulse = 135;
static NSString * const kMovementActionKey = @"Movement";
- (void)keyDown:(NSEvent *)theEvent
{
    unsigned short code = [theEvent keyCode];
    CGVector impulse;
    nodesMoved = YES;
    switch (code) {
        case kVK_LeftArrow:
            impulse = (CGVector){-kImpulse, 0};
            break;
        case kVK_UpArrow:
            impulse = (CGVector){0, kImpulse};
            break;
        case kVK_RightArrow:
            impulse = (CGVector){kImpulse, 0};
            break;
        case kVK_DownArrow:
            impulse = (CGVector){0, -kImpulse};
            break;
        default:
            nodesMoved = NO;
            return;
    }
    
    for( TFENode * node in allNodes ){
        [node runAction:[SKAction repeatActionForever:[SKAction moveBy:impulse duration:1.0]]
                withKey:kMovementActionKey];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * firstBody = [contact bodyA];
    TFENode * firstNode = (TFENode *)[firstBody node];
    SKPhysicsBody * secondBody = [contact bodyB];
    TFENode * secondNode = (TFENode *)[secondBody node];
    CGPoint position;
    
    if( [firstBody categoryBitMask] != [secondBody categoryBitMask] ){
            [firstNode removeActionForKey:kMovementActionKey];
            [secondNode removeActionForKey:kMovementActionKey];
            return;
    }
    
    // Also, order is important: in the original, when there are multiple
    // combination candidates, the two cells that are farthest in the direction
    // of movement are combined.
    // Further, only one combo takes place per cell per move:
    // |2|2|4| | -> results in | | |4|4|, not | | | |8|
    
    // Find the node that's furthest in the direction of movement.
    // Its _final_ position is the position of the combined node.
    //[self furthestNodeInDirectionOfMovement:@[firstNode, secondNode]];
    if( vectorMagnitude([firstBody velocity]) > 0 ){
        position = [secondNode position];
    }
    else {
        position = [firstNode position];
    }
    
    [firstNode removeFromParent];
    [secondNode removeFromParent];
    [allNodes removeObject:firstNode];
    [allNodes removeObject:secondNode];
    
    TFENode * newNode = [TFENode nodeWithValue:[firstNode value] * 2
                                      position:position];
    [self addChild:newNode];
    [allNodes addObject:newNode];
}

static const CGFloat kGridSquareBorder = 10;
- (CGPoint)centerOfGridSquare:(NSUInteger)squareNumber
{
    CGFloat minDimension = MIN([self size].width, [self size].height);
    CGFloat gridSquareSize = minDimension / 4;
    NSUInteger col = (squareNumber % 4);
    NSUInteger row = (squareNumber / 4);
    CGFloat x = (gridSquareSize / 2) + ((gridSquareSize + kGridSquareBorder) * col);
    CGFloat y = (gridSquareSize / 2) + ((gridSquareSize + kGridSquareBorder) * row);
    
    return (CGPoint){x, y};
}

- (NSUInteger)gridSquareForPosition:(CGPoint)position
{
    CGFloat minDimension = MIN([self size].width, [self size].height);
    CGFloat gridSquareSize = minDimension / 4;
    NSUInteger col = position.x / (gridSquareSize + kGridSquareBorder);
    NSUInteger row = position.y / (gridSquareSize + kGridSquareBorder);
    
    return (row * 4) + col;
}

- (NSIndexSet *)unoccupiedGridSquares
{
    NSMutableIndexSet * set = [NSMutableIndexSet indexSetWithIndexesInRange:(NSRange){0, 15}];
    for( TFENode * node in allNodes ){
        [set removeIndex:[self gridSquareForPosition:[node position]]];
    }
    return set;
}

- (void)didSimulatePhysics
{
    if( nodesMoved ){
        
        if( [allNodes count] >= 16 ){
            return;
        }
        NSIndexSet * unoccupiedSquares = [self unoccupiedGridSquares];
        
        uint32_t val = (arc4random_uniform(2) + 1) * 2;
        NSUInteger idx = [unoccupiedSquares TFERandomIndex];
        CGPoint position = [self centerOfGridSquare:idx];
        TFENode * node = [TFENode nodeWithValue:val position:position];
        
        [self addChild:node];
        [allNodes addObject:node];
        nodesMoved = NO;
    }
}

@end

CGFloat vectorMagnitude(CGVector vector)
{
    return sqrt(pow(vector.dx, 2) + pow(vector.dx, 2));
}
