//
//  TFENode.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFENode.h"

static CGFloat randomOffsetWithGamut(CGFloat gamut)
{
    return gamut * ((CGFloat)arc4random() / UINT32_MAX) - (gamut / 2);
}

@interface TFENode ()

+ (SKTexture *)textureForValue:(uint32_t)value;

/** The TFENode class tracks whether any instances are running animations.
 *  This dispatch group is the means. An instance enters the group before
 *  starting its animation action, and leaves the group in the action's
 *  completion.
 */
+ (dispatch_group_t)movementDispatchGroup;

- (void)moveToPosition:(CGPoint)destination duration:(CGFloat)duration;

@end

@implementation TFENode

+ (instancetype)nodeWithValue:(uint32_t)value
{
    SKTexture * texture = [self textureForValue:value];
    id node = [[self alloc] initWithTexture:texture];
    
    [node setSize:(CGSize){100, 100}];
    [(TFENode *)node setValue:value];
    
    return node;
}

+ (void)waitOnAllNodeMovement
{
    dispatch_group_wait([self movementDispatchGroup], DISPATCH_TIME_FOREVER);
}

+ (BOOL)anyNodeMovementInProgress
{
    // Return immediately regardless, but signal whether it was because
    // the group is inactive or because of timeout.
    return 0 != dispatch_group_wait([self movementDispatchGroup],
                                    DISPATCH_TIME_NOW);
}

+ (SKTexture *)textureForValue:(uint32_t)value
{
    NSString * name = [NSString stringWithFormat:@"%d", value];
    return [SKTexture textureWithImageNamed:name];
}

+ (dispatch_group_t)movementDispatchGroup
{
    static dispatch_group_t group;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        group = dispatch_group_create();
    });
    
    return group;
}

- (BOOL)isEqual:(id)other
{
    if( ![other isKindOfClass:[self class]] ){
        return NO;
    }
    
    return [self value] == [(TFENode *)other value];
}

- (NSUInteger)hash
{
    return [[self class] hash] << [self value];
}

- (CGFloat)resizeFadeDuration
{
    static const CGFloat kNodeResizeFadeDuration = 0.19;
    CGFloat gamut = 0.08;
    CGFloat offset = randomOffsetWithGamut(gamut);
    return kNodeResizeFadeDuration + offset;
}

- (CGFloat)bounceDuration
{
    static const CGFloat kNodeBounceDuration = 0.06;
    CGFloat gamut = 0.08;
    CGFloat offset = randomOffsetWithGamut(gamut);
    return kNodeBounceDuration + offset;
}

- (CGFloat)moveDuration
{
    static const CGFloat kNodeMoveDuration = 0.125;
    CGFloat gamut = 0.08;
    CGFloat offset = randomOffsetWithGamut(gamut);
    return kNodeMoveDuration + offset;
}

-(void)spawnAtPosition:(CGPoint)position
{
    static const CGFloat kInitialScale = 0.85;
    static const CGFloat kBounceUpperScale = 1.1;
    static const CGFloat kBounceLowerScale = 0.93;
    static const CGFloat kUnityScale = 1.0;

    CGFloat thisResizeDuration = [self resizeFadeDuration];
    CGFloat thisBounceDuration = [self bounceDuration];
    
    // Grow to full size
    [self setScale:kInitialScale];
    SKAction * grow = [SKAction scaleTo:kUnityScale duration:thisResizeDuration];
    
    // Do a little size bounce
    SKAction * scaleUp = [SKAction scaleTo:kBounceUpperScale duration:thisBounceDuration];
    SKAction * scaleDown = [SKAction scaleTo:kBounceLowerScale duration:thisBounceDuration];
    SKAction * scaleBackUp = [SKAction scaleTo:kUnityScale duration:thisBounceDuration];
    SKAction * bounceScale = [SKAction sequence:@[scaleUp, scaleDown, scaleBackUp]];
    
    SKAction * spawn = [SKAction sequence:@[grow, bounceScale]];

    [self setPosition:position];
    [self runAction:spawn];
}

- (void)moveToPosition:(CGPoint)destination
{
    [self moveToPosition:destination duration:[self moveDuration]];
}

- (void)moveIntoCombinationAtPosition:(CGPoint)destination
{
    static const CGFloat kFinalShrinkScale = 0.25;
    
    BOOL changingPosition = !CGPointEqualToPoint(destination, [self position]);
    
    CGFloat thisResizeDuration = [self resizeFadeDuration];
    SKAction * shrink = [SKAction scaleTo:kFinalShrinkScale duration:thisResizeDuration];
    SKAction * fade = [SKAction fadeOutWithDuration:thisResizeDuration];
    
    SKAction * fadeAndShrink = [SKAction group:@[shrink, fade]];

    if( changingPosition ){

        CGFloat thisMoveDuration = [self moveDuration];
        fadeAndShrink = [SKAction sequence:@[[SKAction waitForDuration:thisMoveDuration], fadeAndShrink]];
        [self moveToPosition:destination duration:thisMoveDuration];
    }
    
    // Disappear animation does not prevent spawning
    [self runAction:fadeAndShrink
         completion:^{
        
            // Next run loop
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromParent];
            });
    }];
}

- (void)moveToPosition:(CGPoint)destination duration:(CGFloat)duration
{
    SKAction * move = [SKAction moveTo:destination duration:duration];
    [move setTimingMode:SKActionTimingEaseInEaseOut];
    
    dispatch_group_enter([TFENode movementDispatchGroup]);
    [self runAction:move
         completion:^{ dispatch_group_leave([TFENode movementDispatchGroup]); }];
}

@end
