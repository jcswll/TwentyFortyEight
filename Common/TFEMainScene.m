//
//  TFEMainScene.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEMainScene.h"
#import "TFEMainScene+SlowForDebug.h"
#import "TFENode.h"

@interface TFEMainScene ()

+ (SKColor *)whiteColor;
+ (SKColor *)blackColor;

/** The size for all the tile nodes in the scene. They are always square. */
@property (nonatomic) CGFloat nodeSize;

/** Determine the correct size for a node based on the scene size. */
- (void)calculateNodeSize;

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
}

+ (SKColor *)whiteColor
{
    return [SKColor colorWithRed:243.0/255 green:242.0/255 blue:230.0/255 alpha:1.0];
}

+ (SKColor *)blackColor
{
    return [SKColor colorWithRed:33.0/255 green:30.0/255 blue:0 alpha:1.0];
}

- (BOOL)anyMovementInProgress
{
    return [TFENode anyNodeMovementInProgress];
}

- (void)didMoveToView:(SKView *)view
{
    if( _didCreateContent ){
        return;
    }
    
    _didCreateContent = YES;
    
    [self setBackgroundColor:[[self class] whiteColor]];
    [self calculateNodeSize];
}

- (void)didChangeSize:(CGSize)oldSize
{
    [self calculateNodeSize];
}

- (void)calculateNodeSize
{
    // Nodes will be inset from their grid squares by (square_size / inset_factor) on all sides.
    static const CGFloat kNodeSizeInsetFactor = 8;
    
    CGFloat minDimension = MIN([self size].width, [self size].height);
    CGFloat gridSquareSize = minDimension / 4;
    
    [self setNodeSize:gridSquareSize - (2 * gridSquareSize / kNodeSizeInsetFactor)];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [TFENode waitOnAllNodeMovement];
        dispatch_async(dispatch_get_main_queue(), ^{

            [self addChild:node];
            [node setSize:CGSizeMake([self nodeSize], [self nodeSize])];
            [node spawnAtPosition:[self centerOfGridSquare:square]];
        });
    });
}

- (void)gameDidEndInVictory:(BOOL)victorious
{
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"Krungthep"];
    [label setFontColor:[[self class] blackColor]];
    [label setFontSize:108];
    CGSize size = [self size];
    [label setPosition:(CGPoint){size.width/2, size.height/2}];
    NSString * message = victorious ? @"You won!" : @"Game over";
    [label setText:message];
    
    dispatch_queue_t wait_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(wait_queue, ^{
        
        [TFENode waitOnAllNodeMovement];
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_queue_t ui_queue = dispatch_get_main_queue();
        
        dispatch_after(delay, ui_queue, ^{
            [self addChild:label];
        });
    });
}

@end
