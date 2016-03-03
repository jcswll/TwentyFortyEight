//
//  TFEMainScene.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEMainScene.h"
#import "TFEBoard.h"
#import "TFENode.h"
// Include Carbon header for key code enum
#import <Carbon/Carbon.h>

@interface TFEMainScene ()

/** Point for the center of the grid square at the given index. 0-based,
 * counting from bottom left.
 */
- (CGPoint)centerOfGridSquare:(NSUInteger)squareNumber;
- (NSUInteger)gridSquareForPosition:(CGPoint)position;

@end

@implementation TFEMainScene
{
    BOOL createdContent;
    TFEBoard * board;
}

- (void)didMoveToView:(SKView *)view
{
    if( createdContent ){
        return;
    }
    
    createdContent = YES;
    board = [TFEBoard boardWithScene:self];
}

static NSString * const kMovementActionKey = @"Movement";
- (void)keyDown:(NSEvent *)theEvent
{
    if( 0 != dispatch_group_wait([TFENode movementDispatchGroup], DISPATCH_TIME_NOW)){
        return;
    }
    
    unsigned short code = [theEvent keyCode];
    TFENodeDirection direction;
    switch (code) {
        case kVK_LeftArrow:
            direction = TFENodeDirectionLeft;
            break;
        case kVK_UpArrow:
            direction = TFENodeDirectionUp;
            break;
        case kVK_RightArrow:
            direction = TFENodeDirectionRight;
            break;
        case kVK_DownArrow:
            direction = TFENodeDirectionDown;
            break;
        default:
            /* No movement for other keys */
            return;
    }
    
    [board moveNodesInDirection:direction];
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

- (void)moveNode:(TFENode *)node
    toGridSquare:(NSUInteger)square
       combining:(BOOL)combining
{
    CGPoint destination = [self centerOfGridSquare:square];
    if( combining ){
        [node moveIntoCombinationAtPosition:destination];
    }
    else {
        [node moveToPosition:destination];
    }
    
}

- (void)spawnNode:(TFENode *)node inSquare:(NSUInteger)square
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       dispatch_group_wait([TFENode movementDispatchGroup], DISPATCH_TIME_FOREVER);
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           [self addChild:node];
                           [node spawnAtPosition:[self centerOfGridSquare:square]];
                       });
                   });
}

- (void)gameDidEndInVictory:(BOOL)victorious
{
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"Palatino"];
    [label setFontColor:[NSColor blueColor]];
    [label setFontSize:128];
    CGSize size = [self size];
    [label setPosition:(CGPoint){size.width/2, size.height/2}];
    NSString * message = victorious ? @"You won!" : @"You lost";
    [label setText:message];
    
    [self addChild:label];
}

@end

CGFloat vectorMagnitude(CGVector vector)
{
    return sqrt(pow(vector.dx, 2) + pow(vector.dx, 2));
}
