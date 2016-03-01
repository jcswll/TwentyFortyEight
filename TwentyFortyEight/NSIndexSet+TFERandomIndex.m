//
//  NSIndexSet+TFERandomIndex.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "NSIndexSet+TFERandomIndex.h"

@implementation NSIndexSet (TFERandomIndex)

- (NSUInteger)TFERandomIndex
{
    __block uint32_t count = 0;
    __block NSUInteger retVal = 0;
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        count++;
        if( 0 == arc4random_uniform(count) ){
            retVal = idx;
        }
    }];
    
    return retVal;
}

@end
