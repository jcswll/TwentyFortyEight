//
//  TFENode.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TFENode : SKSpriteNode

+ (instancetype)nodeWithValue:(uint32_t)value;
+ (dispatch_group_t)movementDispatchGroup;

@property (nonatomic) uint32_t value;

- (void)spawnAtPosition:(CGPoint)position;
- (void)moveToPosition:(CGPoint)destination;
- (void)moveIntoCombinationAtPosition:(CGPoint)destination;

@end
