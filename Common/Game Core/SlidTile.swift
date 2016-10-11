//
//  SlidTile.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

/**
 * Representation of tiles while a row is being slid. There are three states:
 * Empty, Solo, or Combined. Combined states are made from two adjacent tiles
 * that have the same value.
 *
 * The tiles themselves are stored in the associated values.
 */
enum SlidTile<T : Tile>
{
    case combined(T, T)
    case solo(T)
    case empty
    
    init(_ tile: T? = nil)
    {
        if let soloTile = tile {
            self = .solo(soloTile)
        }
        else {
            self = .empty
        }
    }
    
    init(_ first: T, _ second: T)
    {
        self = .combined(first, second)
    }
}

/* SlidTile conforms to Equatable so that arrays of them can be compared. */
func ==<T: Tile>(left: SlidTile<T>, right: SlidTile<T>) -> Bool
{
    switch (left, right) {
        
        case let (.solo(leftTile), .solo(rightTile)) where leftTile == rightTile:
            return true
        case let (.combined(leftTile), .combined(rightTile)) where leftTile == rightTile:
            return true
        case (.empty, .empty):
            return true
        default:
            return false
    }
}

extension SlidTile : Equatable {}
