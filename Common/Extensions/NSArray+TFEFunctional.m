//
//  NSArray+TFEFunctional.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "NSArray+TFEFunctional.h"

@implementation NSArray (TFEFunctional)

- (id)TFEFoldWithInitial:(id)initial usingFolder:(TFEFolder)folder
{
    for( id value in self ){
        initial = folder(initial, value);
    }
    
    return initial;
}

- (NSArray *)TFETail
{
    NSUInteger count = [self count];
    return [self subarrayWithRange:(NSRange){1, count-1}];
}

- (NSArray *)TFEFilter:(TFEFilter)filter
{
    BOOL (^test)(id, NSUInteger, BOOL *) =
    ^BOOL (id obj, NSUInteger idx, BOOL * stop){
        return filter(obj);
    };
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:test]];
}

@end
