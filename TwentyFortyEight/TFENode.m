//
//  TFENode.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFENode.h"

static const CGFloat kNodeBounceDuration = 0.06;
static const CGFloat kNodeMoveDuration = 0.125;
static const CGFloat kNodeResizeFadeDuration = 0.19;

@implementation TFENode

+ (instancetype)nodeWithValue:(uint32_t)value
{
    id node = [[self alloc] initWithColor:[NSColor yellowColor]
                                     size:(CGSize){100, 100}];
    
    [(TFENode *)node setValue:value];
    
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"Palatino"];
    [label setText:[NSString stringWithFormat:@"%u", value]];
    [label setFontSize:64];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    
    [node addChild:label];
    
    return node;
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

- (void)spawnAtPosition:(CGPoint)position
{
    SKAction * grow = [[SKAction resizeToWidth:0
                                        height:0
                                      duration:kNodeResizeFadeDuration]
                       reversedAction];
    SKAction * scale = [SKAction scaleBy:1.1 duration:kNodeResizeFadeDuration];
    SKAction * spawn =
        [SKAction group:@[grow,
                             [SKAction fadeInWithDuration:kNodeResizeFadeDuration],
           scale, [SKAction scaleBy:1.0 duration:kNodeBounceDuration]]];
    [self setPosition:position];
    [self runAction:spawn];
}

- (void)moveToPosition:(CGPoint)destination
{
    dispatch_group_enter([TFENode movementDispatchGroup]);
    [self runAction:[SKAction moveTo:destination
                            duration:kNodeMoveDuration]
         completion:^{
             dispatch_group_leave([TFENode movementDispatchGroup]);
     }];
}

- (void)moveIntoCombinationAtPosition:(CGPoint)destination
{
    SKAction * disappear =
        [SKAction group:@[[SKAction moveTo:destination
                                  duration:kNodeMoveDuration],
                          [SKAction resizeToWidth:0
                                           height:0
                                         duration:kNodeMoveDuration * 1.5],
                          [SKAction fadeOutWithDuration:kNodeMoveDuration * 1.5]]];
    
    
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
