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

/** Switch the scene's speed between 0.1 and 1.0 for checking animations. */
- (void)toggleSlowForDebug;

@end

@implementation TFEMainScene
{
    BOOL _didCreateContent;
    TFEBoard * _board;
    SKLabelNode * _scoreLabel;
}

- (void)didMoveToView:(SKView *)view
{
    if( _didCreateContent ){
        return;
    }
    
    _didCreateContent = YES;
    _board = [TFEBoard boardWithScene:self];
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Palatino"];
    [_scoreLabel setFontColor:[NSColor whiteColor]];
    [_scoreLabel setFontSize:27];
    [_scoreLabel setText:@"0"];
    [_scoreLabel setPosition:(CGPoint){CGRectGetMidX([view bounds]),
                                       CGRectGetMidY([view bounds])}];
    [self addChild:_scoreLabel];
}

- (void)keyDown:(NSEvent *)theEvent
{
    if( NSControlKeyMask == ([theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) ){
        if( kVK_ANSI_S == [theEvent keyCode] ){
            [self toggleSlowForDebug];
            return;
        }
    }
    
    // Don't accept input while movement is taking place.
    if( [TFENode anyNodeMovementInProgress] ){
        return;
    }
    
    unsigned short code = [theEvent keyCode];
    TFENodeDirection direction;
    switch (code) {
        case kVK_ANSI_A:
        case kVK_LeftArrow:
            direction = TFENodeDirectionLeft;
            break;
        case kVK_ANSI_W:
        case kVK_UpArrow:
            direction = TFENodeDirectionUp;
            break;
        case kVK_ANSI_D:
        case kVK_RightArrow:
            direction = TFENodeDirectionRight;
            break;
        case kVK_ANSI_S:
        case kVK_DownArrow:
            direction = TFENodeDirectionDown;
            break;
        default:
            /* No movement for other keys */
            return;
    }
    
    [_board moveNodesInDirection:direction];
}

- (CGPoint)centerOfGridSquare:(NSUInteger)squareNumber
{
    CGFloat minDimension = MIN([self size].width, [self size].height);
    CGFloat gridSquareSize = minDimension / 4;
    NSUInteger col = (squareNumber % 4);
    NSUInteger row = (squareNumber / 4);
    CGFloat x = gridSquareSize * (col + 0.5);
    CGFloat y = gridSquareSize * (row + 0.5);
    
    return (CGPoint){x, y};
}

- (void)toggleSlowForDebug
{
    static BOOL fullSpeed = YES;
    fullSpeed = !fullSpeed;
    [self setSpeed:fullSpeed ? 1.0 : 0.1];
}

#pragma mark - Board commnunication

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
    // Wait until all other movement has stopped before running the animation
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
            [TFENode waitOnAllNodeMovement];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       [TFENode waitOnAllNodeMovement];
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           
                           [self addChild:label];
                       });
                   });
}

- (void)updateScoreTo:(uint32_t)new_score
{
    [_scoreLabel setText:[NSString stringWithFormat:@"%d", new_score]];
}

@end
