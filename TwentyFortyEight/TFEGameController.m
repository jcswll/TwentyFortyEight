//
//  TFEGameController.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEGameController.h"
#import "TFEMainScene.h"
#import "TFEMainScene+SlowForDebug.h"
#import "TFEBoard.h"
#import "TFELabel.h"
// Include Carbon header for key code enum
#import <Carbon/Carbon.h>

@interface TFEGameController ()

- (instancetype)initWithScene:(TFEMainScene *)scene;

@property (strong, nonatomic) TFEMainScene * scene;
@property (strong, nonatomic) TFEBoard * board;

@end

@implementation TFEGameController
{
    uint32_t _score;
}

+ (instancetype)controllerForScene:(TFEMainScene *)scene
{
    return [[self alloc] initWithScene:scene];
}

- (instancetype)initWithScene:(TFEMainScene *)scene
{
    self = [super init];
    if( !self ) return nil;
    
    _scene = scene;
    _board = [TFEBoard boardWithController:self
                                     scene:scene];
    
    return self;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

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
    
    [[self board] moveNodesInDirection:direction];
}

//MARK: Board communication

- (void)gameDidEndInVictory:(BOOL)victorious
{
    [[self scene] gameDidEndInVictory:victorious];
}

- (void)updateScoreTo:(uint32_t)new_score
{
    [[self scoreLabel] setText:[NSString stringWithFormat:@"%d", new_score]];
}

@end
