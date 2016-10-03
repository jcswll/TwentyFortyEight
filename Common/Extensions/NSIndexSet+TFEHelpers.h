//
//  NSIndexSet+TFEHelpers.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import Foundation;

@interface NSIndexSet (TFEHelpers)

/** Return an index set initialized with count items from an array of
 *  NSUInteger.
 */
+ (instancetype)TFEIndexSetWithIntegers:(const NSUInteger *)integers
                                  count:(NSUInteger)count;

/** Return a uniformly-randomly chosen index from the set. */
- (NSUInteger)TFERandomIndex;

@end
