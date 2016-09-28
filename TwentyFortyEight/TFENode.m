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
    // Grow to full size
    CGSize size = [self size];
    [self setSize:(CGSize){0,0}];
    SKAction * grow = [SKAction resizeToWidth:size.width
                                        height:size.height
                                      duration:[self resizeFadeDuration]];
    // Do a little size bounce
    SKAction * wait = [SKAction waitForDuration:[self resizeFadeDuration] * 0.9];
    SKAction * scaleUp = [SKAction scaleTo:1.2 duration:[self bounceDuration]];
    SKAction * scaleDown = [SKAction scaleTo:0.9 duration:[self bounceDuration]];
    SKAction * scaleBackUp = [SKAction scaleTo:1.0 duration:[self bounceDuration]];
    // And fade in
    SKAction * fade = [SKAction fadeInWithDuration:[self resizeFadeDuration]];
    SKAction * spawn = [SKAction group:@[grow, fade,
                         [SKAction sequence:@[wait, scaleUp,
                                              scaleDown, scaleBackUp]]]];

    [self setPosition:position];
    [self runAction:spawn];
}

- (void)moveToPosition:(CGPoint)destination
{
    dispatch_group_enter([TFENode movementDispatchGroup]);
    SKAction * move = [SKAction moveTo:destination
                              duration:[self moveDuration]];
    [move setTimingMode:SKActionTimingEaseInEaseOut];
    [self runAction:move
         completion:^{
             dispatch_group_leave([TFENode movementDispatchGroup]);
     }];
}

- (void)moveIntoCombinationAtPosition:(CGPoint)destination
{
    SKAction * disappear =
        [SKAction group:@[[SKAction moveTo:destination
                                  duration:[self moveDuration]],
                          [SKAction resizeToWidth:0
                                           height:0
                                         duration:[self moveDuration] * 1.5],
                          [SKAction fadeOutWithDuration:[self moveDuration] * 1.5]]];
    
    
    dispatch_group_enter([TFENode movementDispatchGroup]);
    [self runAction:disappear
         completion:
          ^{
              dispatch_group_leave([TFENode movementDispatchGroup]);
              dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [self removeFromParent];
                        });
          }];
}

@end
