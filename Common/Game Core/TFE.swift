//
//  TFE.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import Foundation

/**
 * Construct a starting grid; the grid is empty except for two tiles created
 * by spawnNewTile(on:)
 *
 * Returns an array of `TileMove`s describing the spawns, and the new grid.
 */
public func buildGrid<T : Tile>() -> ([TileMove<T>], [T?])
{
    var grid: [T?] = nullGrid()
    
    let firstSpawn: TileMove<T>
    let secondSpawn: TileMove<T>
    
    (firstSpawn, grid) = spawnNewTile(on: grid)
    (secondSpawn, grid) = spawnNewTile(on: grid)
    
    return ([firstSpawn, secondSpawn], grid)
}

/**
 * Attempt to slide all the tiles towards the given direction.
 *
 * Returns an array of `TileMove`s, or `nil` if nothing moved, and the grid as
 * reconfigured after all movement.
 */
public func moveTiles<T : Tile>(_ grid: [T?], inDirection direction: SlideDirection) -> ([TileMove<T>]?, [T?])
{
    var newGrid: [T?] = nullGrid()
    var moves: [TileMove<T>]? = nil
    
    // The by-row and intra-row traversal orders depend on the direction
    // of movement. GridIndexes holds the square positions in the
    // correct orders
    for rowIndexes in GridIndexes.by(direction) {
        
        let row = grid.elements(at: rowIndexes)
        
        let slid = slideRow(row)
        
        // No movement, just copy tiles over and continue with the next row.
        guard let slidRow = slid else {
            
            for index in rowIndexes {
                newGrid[index] = grid[index]
            }
            
            continue
        }
        
        moves = moves ?? []
        
        let newMoves: [TileMove<T>]
        (newMoves, newGrid) = processMoves(forSlidRow: slidRow, rowIndexes: rowIndexes, onGrid: newGrid)
        moves?.append(contentsOf: newMoves)
    }
    
    return (moves, newGrid)
}


/**
 * Create a new tile at a random index selected from those that are both
 * unoccupied and not in the line furthest in the disallowed direction.
 * The tile has value 2 or 4, chosen at random.
 *
 * Returns a `TileMove` object describing the spawn and the grid with the
 * new tile added.
 */
public func spawnNewTile<T : Tile>(on grid: [T?], excluding direction: SlideDirection) -> (TileMove<T>, [T?])
{
    let disallowedIndexes = TrailingSquares.awayFrom(direction)
    return spawnNewTile(on: grid, excluding: disallowedIndexes)
}

public func isAWinner<T : Tile>(_ grid: [T?]) -> Bool
{
    return grid.contains(where: { $0?.value == 2048 })
}

public func isALoser<T : Tile>(_ grid: [T?]) -> Bool
{
    // If the board isn't full, we can't have lost yet
    guard !indexesOfUnoccupiedSquares(grid).isEmpty else {
        return false
    }
    
    // Try moving in all directions
    let directions: [SlideDirection] = [.left, .up, .right, .down]
    for direction in directions {
        
        let (moves, _) = moveTiles(grid, inDirection: direction)
        
        // If movement is possible in _any_ direction, we haven't lost
        guard moves == nil else {
            return false
        }
    }
    
    return true
}

public func score<T : Tile>(forMoves moves: [TileMove<T>]) -> Int
{
    return moves.reduce(0, { (score, move) in
        
        guard move.isCombination else {
            return 0
        }
        
        return score + move.tile.value
    })
}

//MARK: - Internal functions

/** Array of `Optional<T>.None` representing an empty grid. */
func nullGrid<T : Tile>() -> [T?]
{
    return Array(repeating: nil, count: 16)
}

/**
 * Given a list of optional `Tile`s, representing the game grid, return a set
 * with the indexes of all nil elements.
 */
func indexesOfUnoccupiedSquares<T : Tile>(_ grid: [T?]) -> Set<Int>
{
    var set: Set<Int> = []
    
    for (i, v) in grid.enumerated() {
        if v == nil {
            set.insert(i)
        }
    }
    
    return set
}

/**
 * Given a list of `SlidTile`s and the grid indexes of the corresponding row,
 * deconstruct the enums into `TileMove`s and update the tile locations in the
 * grid, or create new tiles for combinations, as necessary.
 *
 * Returns the list of moves and the updated grid.
 */
func processMoves<T : Tile>(forSlidRow row: [SlidTile<T>], rowIndexes indexes: [Int], onGrid grid: [T?]) -> ([TileMove<T>], [T?])
{
    var newGrid = grid
    var moves: [TileMove<T>] = []
    
    for (destination, slidTile) in zip(indexes, row) {
    
        let tileForDestination: T
    
        switch slidTile {
        
            case .empty:
                continue
            case let .solo(tile):
                tileForDestination = tile
                moves.append(TileMove(tile: tile, destination: destination))
            case let .combined(firstTile, secondTile):
                moves.append(TileMove(tile: firstTile, destination: destination, isCombination: true))
                moves.append(TileMove(tile: secondTile, destination: destination, isCombination: true))
                let comboTile = T(value: firstTile.value * 2)
                tileForDestination = comboTile
                moves.append(TileMove(tile: comboTile, destination: destination, isSpawn: true))
        }
    
        newGrid[destination] = tileForDestination
    }
    
    return (moves, newGrid)
}

/**
 * Given an array of optional `Tile`s representing a grid row, move the values
 * leftwards (towards the beginning of the array), allowing tiles that contain
 * values to skip over empty squares and combining adjacent tiles that have the
 * same value.
 *
 * Return `nil` if nothing changed, or an array of `SlidTile`s representing the
 * moved tiles for further processing.
 */
func slideRow<T : Tile>(_ row: [T?]) -> [SlidTile<T>]?
{
    let realTiles: [T] = row.flatMap({ $0 })
    
    guard !realTiles.isEmpty else {
        return nil
    }
    
    /**
     * Perform the combinations of adjacent tiles as a left fold:
     * `accum` initially holds the first element of the row as a `SlidTile`,
     * then collects each new element as it is processed. When two `.Solo` tiles
     * are moved into one another, they create a single `.Combined`, with the
     * same associated value.
     */
    func slide(accum: [SlidTile<T>], next: T) -> [SlidTile<T>]
    {
        switch accum.last! {
            
            case let .solo(last) where last == next:
                return accum.dropLast() + [SlidTile(last, next)]
            default:
                return accum + [SlidTile(next)]
        }
    }
    
    let (first, rest) = (realTiles.first!, realTiles.dropFirst())
    let slidRow = rest.reduce([SlidTile(first)], slide)
    
    // "Fill out" the remainer of the row with SlidTile.Empty values
    let emptiesCount = 4 - slidRow.count
    let filledOutRow = slidRow + Array(repeating: SlidTile(), count: emptiesCount)
    
    // If the slid row after adding empties is equivalent to the original row mapped to
    // SlidTiles, nothing changed.
    let wrappedOriginalRow = row.map({ SlidTile<T>($0) })
    let didMove = (filledOutRow != wrappedOriginalRow)
    
    return didMove ? slidRow : nil
}

/**
 * Does the actual work for the public function `TFESpawnNewTile(on:excluding:)`,
 * which will pass in the disallowed directions.
 *
 * Given the grid and a set of positions that are invalid, add a square with
 * value either 2 or 4 to any empty and valid square, then return the new grid.
 */
func spawnNewTile<T : Tile>(on grid: [T?], excluding disallowedIndexes: Set<Int> = []) -> (TileMove<T>, [T?])
{
    let unoccupiedSquares = indexesOfUnoccupiedSquares(grid)
    let allowedLocations = unoccupiedSquares.subtracting(disallowedIndexes)
    let spawnLocation = allowedLocations.randomInt()!
    
    var newGrid = grid
    // Bias heavily towards new value being a 2
    let pick = arc4random_uniform(10)
    let newValue = (pick < 9) ? 2 : 4
    let tile = T(value: newValue)
    
    let spawn = TileMove(tile: tile, destination: spawnLocation, isSpawn: true)
    newGrid[spawnLocation] = tile
    
    return (spawn, newGrid)
}
