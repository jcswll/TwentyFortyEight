//
//  TFEMoveTests.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import XCTest
@testable import TFE

class TFEMoveTests : XCTestCase
{
    let directions: [SlideDirection] = [.left, .up, .right, .down]
    
    func resetGrid(_ grid: [TestTile?], values: [TestTile?], atIndexes indexes: [Int]) -> [TestTile?]
    {
        var newGrid = grid

        for (index, value) in zip(indexes, values) {
            newGrid[index] = value
        }
        
        return newGrid
    }
    
    func testMoveInitialGrid()
    {
        let node = TestTile(value: 2)
        var grid: [TestTile?] = Array(repeating: nil, count: 16)
        grid[4] = node
        grid[10] = node

        let movesByDirection: [SlideDirection : [TileMove<TestTile>]] =
            [.left : [TileMove(tile: node, destination: 8)],
             .up : [TileMove(tile: node, destination: 12), TileMove(tile: node, destination: 14)],
             .right : [TileMove(tile: node, destination: 7), TileMove(tile: node, destination: 11)],
             .down : [TileMove(tile: node, destination: 0), TileMove(tile: node, destination: 2)]]

        let gridsByDirection: [SlideDirection : [TestTile?]] =
            [.left : resetGrid(grid, values: [node, node, nil], atIndexes: [4, 8, 10]),
             .up : resetGrid(grid, values: [nil, nil, node, node], atIndexes: [4, 10, 12, 14]),
             .right : resetGrid(grid, values: [nil, nil, node, node], atIndexes: [4, 10, 7, 11]),
             .down : resetGrid(grid, values: [nil, nil, node, node], atIndexes: [4, 10, 0, 2])]


        for direction in directions {

            let expectedMoves = movesByDirection[direction]!
            let expectedGrid = gridsByDirection[direction]!

            let (moves, newGrid) = TFE.moveTiles(grid, inDirection: direction)

            XCTAssertEqual(moves!, expectedMoves, "Failed for \(direction)")
            XCTAssert(newGrid == expectedGrid, "Failed for \(direction)")
        }
    }

    //MARK: SlideNodes to moves
    
    func testOneSolo()
    {
        let node = TestTile(value: 2)
        let row = [SlidTile(node)]

        let expectedDestinations: [SlideDirection : [Int]] =
            [.left : [0, 4, 8, 12],
             .up : [12, 13, 14, 15],
             .right : [3, 7, 11, 15],
             .down : [0, 1, 2, 3]]

        let grid: [TestTile?]
        (_, grid) = TFE.buildGrid()
        for direction in directions {

            for (i, rowIndexes) in GridIndexes.by(direction).enumerated() {

                let expectedDestination = expectedDestinations[direction]![i]
                let expectedMove = TileMove(tile: node, destination: expectedDestination)

                let (moves, _) = processMoves(forSlidRow: row, rowIndexes: rowIndexes, onGrid: grid)

                XCTAssertEqual(moves, [expectedMove], "Failed: \(direction) row: \(i)")
            }
        }
    }

    func testTwoSolos()
    {
        let node = TestTile(value: 2)
        let otherNode = TestTile(value: 4)
        let row = [SlidTile(node), SlidTile(otherNode)]

        let expectedDestinations: [SlideDirection : [(Int, Int)]] =
            [.left : [(0, 1), (4, 5), (8, 9), (12, 13)],
             .up : [(12, 8), (13, 9), (14, 10), (15, 11)],
             .right : [(3, 2), (7, 6), (11, 10), (15, 14)],
             .down : [(0, 4), (1, 5), (2, 6), (3, 7)]]

        let grid: [TestTile?]
        (_, grid) = TFE.buildGrid()
        for direction in directions {

            for (i, rowIndexes) in GridIndexes.by(direction).enumerated() {

                let expectedDestination = expectedDestinations[direction]![i].0
                let otherExpectedDestination = expectedDestinations[direction]![i].1
                let expectedMoves = [TileMove(tile: node, destination: expectedDestination),
                                     TileMove(tile: otherNode, destination: otherExpectedDestination)]

                let (moves, _) = processMoves(forSlidRow: row, rowIndexes: rowIndexes, onGrid: grid)

                XCTAssertEqual(moves, expectedMoves, "Failed: \(direction) row: \(i)")
            }
        }
    }

    func testThreeSolos()
    {
        let nodes = [TestTile(value: 2), TestTile(value: 4), TestTile(value: 8)]
        let row = nodes.map({ SlidTile($0) })

        let expectedDestinations: [SlideDirection : [[Int]]] =
            [.left : [[0, 1, 2], [4, 5, 6], [8, 9, 10], [12, 13, 14]],
             .up : [[12, 8, 4], [13, 9, 5], [14, 10, 6], [15, 11, 7]],
             .right : [[3, 2, 1], [7, 6, 5], [11, 10, 9], [15, 14, 13]],
             .down : [[0, 4, 8], [1, 5, 9], [2, 6, 10], [3, 7, 11]]]

        let grid: [TestTile?]
        (_, grid) = TFE.buildGrid()
        for direction in directions {
            
            for (i, rowIndexes) in GridIndexes.by(direction).enumerated() {
                
                let expectedMoves = zip(nodes, expectedDestinations[direction]![i]).map({
                    return TileMove(tile: $0, destination: $1)
                })
                
                let (moves, _) = TFE.processMoves(forSlidRow: row, rowIndexes: rowIndexes, onGrid: grid)
                
                XCTAssertEqual(moves, expectedMoves, "Failed: \(direction) row: \(i)")
            }
        }
    }

    func testSoloAndCombo()
    {
        let node = TestTile(value: 2)
        let otherNode = TestTile(value: 4)
        let row = [SlidTile(TestTile(value: 4)), SlidTile(node, node)]
        let expectedMoves = [TileMove(tile: otherNode, destination: 0),
                             TileMove(tile: node, destination: 1, isCombination: true),
                             TileMove(tile: node, destination: 1, isCombination: true),
                             TileMove(tile: otherNode, destination: 1, isSpawn: true)]

        let grid: [TestTile?]
        (_, grid) = TFE.buildGrid()
        let (moves, _) = TFE.processMoves(forSlidRow: row, rowIndexes: [0, 1, 2, 3], onGrid: grid)

        XCTAssertEqual(moves, expectedMoves)
    }
}

public func ==<T : Tile>(lhs: TileMove<T>, rhs: TileMove<T>) -> Bool
{
    return lhs.tile == rhs.tile &&
           lhs.destination == rhs.destination &&
           lhs.isSpawn == rhs.isSpawn &&
           lhs.isCombination == rhs.isCombination
}

extension TileMove : Equatable {}

func ==(lhs: [TestTile?], rhs: [TestTile?]) -> Bool
{
    guard lhs.count == rhs.count else {
        return false
    }
    
    for (left, right) in zip(lhs, rhs) {
        
        switch (left, right) {
            case (.none, .none):
                continue
            case let (.some(l), .some(r)):
                guard l == r else {
                    return false
                }
            default:
                return false
        }
    }
    
    return true
}
