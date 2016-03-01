//
//  TFENode.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFENode.h"

@implementation TFENode

+ (instancetype)nodeWithValue:(uint32_t)value position:(CGPoint)position
{
    id node = [[self alloc] initWithColor:[NSColor yellowColor]
                                             size:(CGSize){100, 100}];
    [node setPosition:position];
    [node setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:65]];
    [[node physicsBody] setAffectedByGravity:NO];
    [[node physicsBody] setCategoryBitMask:value];
    [[node physicsBody] setContactTestBitMask:UINT32_MAX];
    [[node physicsBody] setAllowsRotation:NO];
    
    [(TFENode *)node setValue:value];
    
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"Palatino"];
    [label setText:[NSString stringWithFormat:@"%u", value]];
    [label setFontSize:64];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    
    [node addChild:label];
    
    return node;
}

@end
