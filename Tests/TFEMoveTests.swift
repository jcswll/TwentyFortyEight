//
//  TFEMoveTests.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import XCTest
@testable import TwentyFortyEight

class TFEMoveTests : XCTestCase
{
    let directions: [TFENodeDirection] = [.Left, .Up, .Right, .Down]
    
    func resetGrid(grid: [TFENode?], values: [TFENode?], atIndexes indexes: [Int]) -> [TFENode?]
    {
        var newGrid = grid

        for (index, value) in zip(indexes, values) {
            newGrid[index] = value
        }
        
        return newGrid
    }
    
    func testMoveInitialGrid()
    {
        let node = TFENode(value: 2)
        var grid: [TFENode?] = Array(count: 16, repeatedValue: nil)
        grid[4] = node
        grid[10] = node

        let movesByDirection: [TFENodeDirection : [TFEMove]] =
            [.Left : [TFEMove(node: node, destination: 8)],
             .Up : [TFEMove(node: node, destination: 12), TFEMove(node: node, destination: 14)],
             .Right : [TFEMove(node: node, destination: 7), TFEMove(node: node, destination: 11)],
             .Down : [TFEMove(node: node, destination: 0), TFEMove(node: node, destination: 2)]]

        let gridsByDirection: [TFENodeDirection : [TFENode?]] =
            [.Left : resetGrid(grid, values: [node, node, nil], atIndexes: [4, 8, 10]),
             .Up : resetGrid(grid, values: [nil, nil, node, node], atIndexes: [4, 10, 12, 14]),
             .Right : resetGrid(grid, values: [nil, nil, node, node], atIndexes: [4, 10, 7, 11]),
             .Down : resetGrid(grid, values: [nil, nil, node, node], atIndexes: [4, 10, 0, 2])]


        for direction in directions {

            let expectedMoves = movesByDirection[direction]!
            let expectedGrid = gridsByDirection[direction]!

            let (moves, newGrid) = TFEMoveNodes(grid, inDirection: direction)

            XCTAssertEqual(moves!, expectedMoves, "Failed for \(direction)")
            XCTAssert(newGrid == expectedGrid, "Failed for \(direction)")
        }
    }

    //MARK: SlideNodes to moves
    
    func testOneSolo()
    {
        let node = TFENode(value: 2)
        let row = [SlidNode(node)]

        let expectedDestinations: [TFENodeDirection : [Int]] =
            [.Left : [0, 4, 8, 12],
             .Up : [12, 13, 14, 15],
             .Right : [3, 7, 11, 15],
             .Down : [0, 1, 2, 3]]

        let (_, grid) = TFEBuildGrid()
        for direction in directions {

            for (i, rowIndexes) in GridIndexes.by(direction).enumerate() {

                let expectedDestination = expectedDestinations[direction]![i]
                let expectedMove = TFEMove(node: node, destination: expectedDestination)

                let (moves, _) = processMoves(forSlidRow: row, rowIndexes: rowIndexes, onGrid: grid)

                XCTAssertEqual(moves, [expectedMove], "Failed: \(direction) row: \(i)")
            }
        }
    }

    func testTwoSolos()
    {
        let node = TFENode(value: 2)
        let otherNode = TFENode(value: 4)
        let row = [SlidNode(node), SlidNode(otherNode)]

        let expectedDestinations: [TFENodeDirection : [(Int, Int)]] =
            [.Left : [(0, 1), (4, 5), (8, 9), (12, 13)],
             .Up : [(12, 8), (13, 9), (14, 10), (15, 11)],
             .Right : [(3, 2), (7, 6), (11, 10), (15, 14)],
             .Down : [(0, 4), (1, 5), (2, 6), (3, 7)]]

        let (_, grid) = TFEBuildGrid()
        for direction in directions {

            for (i, rowIndexes) in GridIndexes.by(direction).enumerate() {

                let expectedDestination = expectedDestinations[direction]![i].0
                let otherExpectedDestination = expectedDestinations[direction]![i].1
                let expectedMoves = [TFEMove(node: node, destination: expectedDestination),
                                     TFEMove(node: otherNode, destination: otherExpectedDestination)]

                let (moves, _) = processMoves(forSlidRow: row, rowIndexes: rowIndexes, onGrid: grid)

                XCTAssertEqual(moves, expectedMoves, "Failed: \(direction) row: \(i)")
            }
        }
    }

    func testThreeSolos()
    {
        let nodes = [TFENode(value: 2), TFENode(value: 4), TFENode(value: 8)]
        let row = nodes.map({ SlidNode($0) })

        let expectedDestinations: [TFENodeDirection : [[Int]]] =
            [.Left : [[0, 1, 2], [4, 5, 6], [8, 9, 10], [12, 13, 14]],
             .Up : [[12, 8, 4], [13, 9, 5], [14, 10, 6], [15, 11, 7]],
             .Right : [[3, 2, 1], [7, 6, 5], [11, 10, 9], [15, 14, 13]],
             .Down : [[0, 4, 8], [1, 5, 9], [2, 6, 10], [3, 7, 11]]]

         let (_, grid) = TFEBuildGrid()
         for direction in directions {

             for (i, rowIndexes) in GridIndexes.by(direction).enumerate() {

                 let expectedMoves = zip(nodes, expectedDestinations[direction]![i]).map({
                     return TFEMove(node: $0, destination: $1)
                 })

                 let (moves, _) = processMoves(forSlidRow: row, rowIndexes: rowIndexes, onGrid: grid)

                 XCTAssertEqual(moves, expectedMoves, "Failed: \(direction) row: \(i)")
             }
         }
    }

    func testSoloAndCombo()
    {
        let node = TFENode(value: 2)
        let otherNode = TFENode(value: 4)
        let row = [SlidNode(TFENode(value: 4)), SlidNode(node, node)]
        let expectedMoves = [TFEMove(node: otherNode, destination: 0),
                             TFEMove(node: node, destination: 1, isCombination: true),
                             TFEMove(node: node, destination: 1, isCombination: true),
                             TFEMove(node: otherNode, destination: 1, isSpawn: true)]

        let (_, grid) = TFEBuildGrid()
        let (moves, _) = processMoves(forSlidRow: row, rowIndexes: [0, 1, 2, 3], onGrid: grid)

        XCTAssertEqual(moves, expectedMoves)
    }
}

func ==(lhs: TFEMove, rhs: TFEMove) -> Bool
{
    return lhs.node == rhs.node &&
           lhs.destination == rhs.destination &&
           lhs.isSpawn == rhs.isSpawn &&
           lhs.isCombination == rhs.isCombination
}

extension TFEMove : Equatable {}

func ==(lhs: [TFENode?], rhs: [TFENode?]) -> Bool
{
    guard lhs.count == rhs.count else {
        return false
    }
    
    for (left, right) in zip(lhs, rhs) {
        
        switch (left, right) {
            case (.None, .None):
                continue
            case let (.Some(l), .Some(r)):
                guard l == r else {
                    return false
                }
            default:
                return false
        }
    }
    
    return true
}

extension TFENode {
    
    override var description: String {
        return "<Node: \(self.value)>"
    }
}
