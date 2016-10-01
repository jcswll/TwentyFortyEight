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
    CGFloat thisResizeDuration = [self resizeFadeDuration];
    CGFloat thisBounceDuration = [self bounceDuration];
    // Grow to full size
    CGSize size = [self size];
    [self setSize:(CGSize){size.height * 0.85, size.width * 0.85}];
    SKAction * grow = [SKAction resizeToWidth:size.width
                                        height:size.height
                                      duration:thisResizeDuration];
    
    // Do a little size bounce
    SKAction * wait = [SKAction waitForDuration:thisResizeDuration * 0.9];
    SKAction * scaleUp = [SKAction scaleTo:1.1 duration:thisBounceDuration];
    SKAction * scaleDown = [SKAction scaleTo:0.93 duration:thisBounceDuration];
    SKAction * scaleBackUp = [SKAction scaleTo:1.0 duration:thisBounceDuration];
    SKAction * bounceScale = [SKAction sequence:@[wait, scaleUp, scaleDown, scaleBackUp]];
    
    SKAction * spawn = [SKAction group:@[grow, bounceScale]];

    [self setPosition:position];
    [self runAction:spawn];
}

- (void)moveToPosition:(CGPoint)destination
{
    SKAction * move = [SKAction moveTo:destination
                              duration:[self moveDuration]];
    [move setTimingMode:SKActionTimingEaseInEaseOut];
    
    dispatch_group_enter([TFENode movementDispatchGroup]);
    [self runAction:move
         completion:^{ dispatch_group_leave([TFENode movementDispatchGroup]); }];
}

- (void)moveIntoCombinationAtPosition:(CGPoint)destination
{
    CGFloat thisMoveDuration = [self moveDuration];
    CGFloat thisResizeDuration = [self resizeFadeDuration];
    SKAction * shrink = [SKAction resizeToWidth:[self size].width / 4
                                         height:[self size].height / 4
                                       duration:thisResizeDuration];
    SKAction * fade = [SKAction fadeOutWithDuration:thisResizeDuration];
    SKAction * move = [SKAction moveTo:destination duration:thisMoveDuration];
    
    SKAction * fadeAndShrink = [SKAction group:@[shrink, fade]];
    
    SKAction * delayedDisappear = [SKAction sequence:@[[SKAction waitForDuration:thisMoveDuration], fadeAndShrink]];
    
    dispatch_group_enter([TFENode movementDispatchGroup]);
    [self runAction:move
         completion:^{ dispatch_group_leave([TFENode movementDispatchGroup]); }];
    
    // Disappear animation does not prevent user input or spawning
    [self runAction:delayedDisappear
         completion:^{
             
             // Next run loop
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self removeFromParent];
             });;
     }];
}

@end
