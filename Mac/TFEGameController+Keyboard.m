//
//  TFEGameController+Keyboard.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/30/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

// Include Carbon header for key code enum
#import <Carbon/Carbon.h>

#import "TFEGameController+Keyboard.h"

#import "TFEGameController+Private.h"
#import "TFEBoard.h"
#import "TFEMainScene.h"
#import "TFEMainScene+SlowForDebug.h"
#import "TFENodeDirection.h"

@implementation TFEGameController (Keyboard)

- (void)keyDown:(NSEvent *)theEvent
{
    if( NSControlKeyMask == ([theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) ){
        if( kVK_ANSI_S == [theEvent keyCode] ){
            [[self scene] toggleSlowForDebug];
            return;
        }
    }
    
    // Don't accept input while movement is taking place.
    if( [[self scene] anyMovementInProgress] ){
        return;
    }
    
    unsigned short code = [theEvent keyCode];
    TFENodeDirection direction = TFENodeDirectionNotADirection;
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
    
    [[self board] moveNodesInDirection:direction];
}

@end
