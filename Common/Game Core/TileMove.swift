//
//  TileMove.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/3/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

/**
 * A `TileMove` encapsulates a single movement of a tile on the game board;
 * it records the destination square and whether the move is a tile's spawn
 * or the combination of two tiles into one.
 */
public struct TileMove<T : Tile>
{
    /** The `Tile` that is moving. */
    public let tile: T
    /** The grid square where the tile is heading or spawning on. */
    public let destination: Int
    /** If `true`, this move involves two tiles colliding and combining. */
    public let isCombination: Bool
    /** If `true`, the tile is being created at the destination rather than moving from somewhere else. */
    public let isSpawn: Bool
    
    init(tile: T, destination: Int, isCombination: Bool = false, isSpawn: Bool = false)
    {
        self.tile = tile
        self.destination = destination
        self.isCombination = isCombination
        self.isSpawn = isSpawn
    }
}
