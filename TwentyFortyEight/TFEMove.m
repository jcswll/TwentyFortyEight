//
//  TFEMove.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 3/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEMove.h"

@implementation TFEMove

+ (instancetype)moveForNode:(TFENode *)node
                   toSquare:(NSUInteger)destination
                  combining:(BOOL)combining 
                   spawning:(BOOL)spawning
{
    return [[self alloc] initWithNode:node
                             toSquare:destination
                            combining:combining
                             spawning:spawning];
}

- (instancetype)initWithNode:(TFENode *)node
                    toSquare:(NSUInteger)destination
                   combining:(BOOL)combining
                    spawning:(BOOL)spawning
{
    self = [super init];
    if( !self ) return nil;
    
    _node = node;
    _destination = destination;
    _combining = combining;
    _spawning = spawning;
    
    return self;
}

@end
