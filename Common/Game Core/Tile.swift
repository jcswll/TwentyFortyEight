//
//  Tile.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/10/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

/**
 * A `Tile` is an item on the TwentyFortyEight game board. Its main feature
 * is its value, which represents its score and is used to compare it to
 * other `Tile`s.
 */
public protocol Tile : Equatable
{
    /** The point value of this `Tile`. */
    var value: Int { get }
    
    /** Create a `Tile` with the given point value. */
    init(value: Int)
}

func ==<T : Tile>(lhs: T, rhs: T) -> Bool
{
    return lhs.value == rhs.value
}
