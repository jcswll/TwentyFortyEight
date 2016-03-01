//
//  TFENode.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TFENode : SKSpriteNode

+ (instancetype)nodeWithValue:(uint32_t)value position:(CGPoint)position;

@property (nonatomic) uint32_t value;

@end
