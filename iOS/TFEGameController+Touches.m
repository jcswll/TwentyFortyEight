//
//  TFEGameController+Touches.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/30/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEGameController+Touches.h"
#import "TFEBoard.h"
#import "TFEMainScene.h"
#import "TFEMainScene+SlowForDebug.h"
#import "TFENodeDirection.h"

@implementation TFEGameController (Touches)

- (void)swipe:(UISwipeGestureRecognizer *)recognizer
{
    // Don't accept input while nodes are moving around
    if( [[self scene] anyMovementInProgress] ){
        return;
    }
    
    UISwipeGestureRecognizerDirection swipeDirection = [recognizer direction];
    TFENodeDirection nodeDirection = TFENodeDirectionNotADirection;
    
    switch( swipeDirection ){
    
        case UISwipeGestureRecognizerDirectionLeft:
            nodeDirection = TFENodeDirectionLeft;
            break;
        case UISwipeGestureRecognizerDirectionUp:
            nodeDirection = TFENodeDirectionUp;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            nodeDirection = TFENodeDirectionRight;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            nodeDirection = TFENodeDirectionDown;
            break;
    }

    [[self board] moveNodesInDirection:nodeDirection];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if( UIGestureRecognizerStateBegan == recognizer.state ){
        [[self scene] toggleSlowForDebug];
    }
}

@end
