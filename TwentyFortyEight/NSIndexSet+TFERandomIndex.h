//
//  NSIndexSet+TFERandomIndex.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (TFERandomIndex)

/** Returns a uniformly-randomly chosen index from the set. */
- (NSUInteger)TFERandomIndex;

@end
