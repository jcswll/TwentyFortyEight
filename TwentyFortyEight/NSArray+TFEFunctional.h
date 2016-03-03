//
//  NSArray+TFEFunctional.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Predicate for -[NSArray TFEFilter:]. Objects in the array for which YES is
 * returned from the filter Block will be present in the filtered result.
 */
typedef BOOL (^TFEFilter)(id);

/** Reduction function for -[NSArray TFEFoldWithInitial:usingFolder:]
 * The first argument is the accumulator; the second is the new value from
 * the array. The value returned from this Block is passed in on the next
 * iteration as the accumulator.
 */
typedef id (^TFEFolder)(id, id);

@interface NSArray (TFEFunctional)

/** An array containing all but the first element of the reciever. */
- (NSArray *)TFETail;

/** Applies the filter Block to each member of the reciever in turn. Returns
 * an array consisting only of those objects for which the filter evaluated
 * to YES.
 */
- (NSArray *)TFEFilter:(TFEFilter)filter;

/** Performs a left fold on the reciever, using initial as the first value for
 * the accumulator.
 */
- (id)TFEFoldWithInitial:(id)initial usingFolder:(TFEFolder)folder;

@end
