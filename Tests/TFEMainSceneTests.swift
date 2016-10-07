//
//  TFEMainSceneTests.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import XCTest
@testable import TwentyFortyEight

class TFEMainSceneTests : XCTestCase
{
    let coordinates: [(CGFloat, CGFloat)] = [(0,0), (0,1), (0,2), (0,3),
                                             (1,0), (1,1), (1,2), (1,3),
                                             (2,0), (2,1), (2,2), (2,3),
                                             (3,0), (3,1), (3,2), (3,3)]

    
    func assertCentersOfSquares(withSide side: CGFloat, inScene scene: TFEMainScene)
    {
        let halfSide = side / 2

        for square in 0..<16 {

            let coord = self.coordinates[square]
            let x = (coord.1 * side) + halfSide
            let y = (coord.0 * side) + halfSide
            let expectedCenter = CGPoint(x: x, y: y)

            let center = scene.center(ofGridSquare: square)

            XCTAssertEqual(center, expectedCenter, "Square \(square) failed.")
        }
    }
    
    func testCenterOfSquaresSmall()
    {
        let squareSide: CGFloat = 123

        let size = CGSize(width: squareSide * 4, height: squareSide * 4)
        let scene = TFEMainScene(size: size)
        
        self.assertCentersOfSquares(withSide: squareSide, inScene: scene)
    }
    
    func testCenterOfSquaresMedium()
    {
        let squareSide: CGFloat = 1234

        let size = CGSize(width: squareSide * 4, height: squareSide * 4)
        let scene = TFEMainScene(size: size)
        
        self.assertCentersOfSquares(withSide: squareSide, inScene: scene)
    }
    
    func testCenterOfSquaresLarge()
    {
        let squareSide: CGFloat = 12345

        let size = CGSize(width: squareSide * 4, height: squareSide * 4)
        let scene = TFEMainScene(size: size)
        
        self.assertCentersOfSquares(withSide: squareSide, inScene: scene)
    }
}
