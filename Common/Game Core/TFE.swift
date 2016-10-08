//
//  TFE.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import Foundation

/**
 * Construct a starting grid; the grid is empty except for two nodes created
 * by spawnNewNode(on:)
 *
 * Returns an array of `TFEMove`s describing the spawns, and the new grid.
 */
func TFEBuildGrid() -> ([TFEMove], [TFENode?])
{
    var grid = nullGrid()
    
    let firstSpawn: TFEMove
    let secondSpawn: TFEMove
    
    (firstSpawn, grid) = spawnNewNode(on: grid)
    (secondSpawn, grid) = spawnNewNode(on: grid)
    
    return ([firstSpawn, secondSpawn], grid)
}

/**
 * Attempt to slide all the nodes towards the given direction.
 *
 * Returns an array of `TFEMove`s, or `nil` if nothing moved, and the grid as
 * reconfigured after all movement.
 */
func TFEMoveNodes(grid: [TFENode?], inDirection direction: TFENodeDirection) -> ([TFEMove]?, [TFENode?])
{
    var newGrid = nullGrid()
    var moves: [TFEMove]? = nil
    
    // The by-row and intra-row traversal orders depend on the direction
    // of movement. GridIndexes holds the square positions in the
    // correct orders
    for rowIndexes in GridIndexes.by(direction) {
        
        let row = grid.elements(at: rowIndexes)
        
        let slid = slideRow(row)
        
        // No movement, just copy nodes over and continue with the next row.
        guard let slidRow = slid else {
            
            for index in rowIndexes {
                newGrid[index] = grid[index]
            }
            
            continue
        }
        
        moves = moves ?? []
        
        let newMoves: [TFEMove]
        (newMoves, newGrid) = processMoves(forSlidRow: slidRow, rowIndexes: rowIndexes, onGrid: newGrid)
        moves?.appendContentsOf(newMoves)
    }
    
    return (moves, newGrid)
}


/**
 * Create a new node at a random index selected from those that are both
 * unoccupied and not in the line furthest in the disallowed direction.
 * The node has value 2 or 4, chosen at random.
 *
 * Returns a `TFEMove` object describing the spawn and the grid with the
 * new node added.
 */
func TFESpawnNewNode(on grid: [TFENode?], excluding direction: TFENodeDirection) -> (TFEMove, [TFENode?])
{
    let disallowedIndexes = TrailingSquares.awayFrom(direction)
    return spawnNewNode(on: grid, excluding: disallowedIndexes)
}

func TFEIsAWinner(grid: [TFENode?]) -> Bool
{
    return grid.contains({ $0?.value == 2048 })
}

func TFEIsALoser(grid: [TFENode?]) -> Bool
{
    // If the board isn't full, we can't have lost yet
    guard !indexesOfUnoccupiedSquares(grid).isEmpty else {
        return false
    }
    
    // Try moving in all directions
    let directions: [TFENodeDirection] = [.Left, .Up, .Right, .Down]
    for direction in directions {
        
        let (moves, _) = TFEMoveNodes(grid, inDirection: direction)
        
        // If movement is possible in _any_ direction, we haven't lost
        guard moves == nil else {
            return false
        }
    }
    
    return true
}

func TFEScore(forMoves moves: [TFEMove]) -> UInt32
{
    return moves.reduce(0, combine: { (score, move) in
        
        guard move.isCombination else {
            return 0
        }
        
        return score + move.node.value
    })
}

//MARK: - Internal functions

/** Array of `Optional<TFENode>.None` representing an empty grid. */
private func nullGrid() -> [TFENode?]
{
    return Array(count: 16, repeatedValue: Optional<TFENode>.None)
}

/**
 * Given a list of optional `TFENode`s, representing the game grid, return a set
 * with the indexes of all nil elements.
 */
private func indexesOfUnoccupiedSquares(grid: [TFENode?]) -> Set<Int>
{
    var set: Set<Int> = []
    
    for (i, v) in grid.enumerate() {
        if v == nil {
            set.insert(i)
        }
    }
    
    return set
}

func processMoves(forSlidRow row: [SlidNode], rowIndexes indexes: [Int], onGrid grid: [TFENode?]) -> ([TFEMove], [TFENode?])
{
    var newGrid = grid
    var moves: [TFEMove] = []
    
    for (destination, slidNode) in zip(indexes, row) {
    
        let nodeForDestination: TFENode
    
        switch slidNode {
        
            case .Empty:
                continue
            case let .Solo(node):
                nodeForDestination = node
                moves.append(TFEMove(node: node, destination: destination))
            case let .Combined(firstNode, secondNode):
                moves.append(TFEMove(node: firstNode, destination: destination, isCombination: true))
                moves.append(TFEMove(node: secondNode, destination: destination, isCombination: true))
                let comboNode = TFENode(value: firstNode.value * 2)
                nodeForDestination = comboNode
                moves.append(TFEMove(node: comboNode, destination: destination, isSpawn: true))
        }
    
        newGrid[destination] = nodeForDestination
    }
    
    return (moves, newGrid)
}

/**
 * Given an array of optional `TFENode`s representing a grid row, move the values
 * leftwards (towards the beginning of the array), allowing nodes that contain
 * values to skip over empty squares and combining adjacent nodes that have the
 * same value.
 *
 * Return `nil` if nothing changed, or an array of `SlidNode`s representing the
 * moved nodes for further processing.
 */
func slideRow(row: [TFENode?]) -> [SlidNode]?
{
    let realNodes: [TFENode] = row.flatMap({ $0 })
    
    guard !realNodes.isEmpty else {
        return nil
    }
    
    /**
     * Perform the combinations of adjacent nodes as a left fold:
     * `accum` initially holds the first element of the row as a `SlidNode`,
     * then collects each new element as it is processed. When two `.Solo` nodes
     * are moved into one another, they create a single `.Combined`, with the
     * same associated value.
     */
    func slide(accum: [SlidNode], next: TFENode) -> [SlidNode]
    {
        switch accum.last! {
            
            case let .Solo(last) where last == next:
                return accum.dropLast() + [SlidNode(last, next)]
            default:
                return accum + [SlidNode(next)]
        }
    }
    
    let (first, rest) = (realNodes.first!, realNodes.dropFirst())
    let slidRow = rest.reduce([SlidNode(first)], combine: slide)
    
    // "Fill out" the remainer of the row with SlidNode.Empty values
    let emptiesCount = 4 - slidRow.count
    let filledOutRow = slidRow + Array(count: emptiesCount, repeatedValue: SlidNode())
    
    // If the slid row after adding empties is equivalent to the original row mapped to
    // SlidNodes, nothing changed.
    let wrappedOriginalRow = row.map({ SlidNode($0) })
    let didMove = (filledOutRow != wrappedOriginalRow)
    
    return didMove ? slidRow : nil
}

/**
 * Does the actual work for the public function `TFESpawnNewNode(on:excluding:)`,
 * which will pass in the disallowed directions.
 *
 * Given the grid and a set of positions that are invalid, add a square with
 * value either 2 or 4 to any empty and valid square, then return the new grid.
 */
private func spawnNewNode(on grid: [TFENode?], excluding disallowedIndexes: Set<Int> = []) -> (TFEMove, [TFENode?])
{
    let unoccupiedSquares = indexesOfUnoccupiedSquares(grid)
    let allowedLocations = unoccupiedSquares.subtract(disallowedIndexes)
    let spawnLocation = allowedLocations.randomInt()!
    
    var newGrid = grid
    let newValue = (arc4random_uniform(2) + 1) * 2
    let node = TFENode(value: newValue)
    
    let spawn = TFEMove(node: node, destination: spawnLocation, isSpawn: true)
    newGrid[spawnLocation] = node
    
    return (spawn, newGrid)
}
