//
//  TFEMove.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 3/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFENode;

@interface TFEMove : NSObject

+ (instancetype)moveForNode:(TFENode *)node
                   toSquare:(NSUInteger)destination
                  combining:(BOOL)combining
                   spawning:(BOOL)spawning;


@property (readonly, nonatomic) TFENode * node;
@property (readonly, nonatomic) NSUInteger destination;
@property (readonly, nonatomic, getter=isCombination) BOOL combining;
@property (readonly, nonatomic, getter=isSpawn) BOOL spawning;

@end
