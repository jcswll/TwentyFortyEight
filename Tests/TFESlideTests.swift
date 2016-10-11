//
//  TFESlideTests.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import XCTest
@testable import TwentyFortyEight

class TFESlideTests : XCTestCase
{
    //MARK: - No movement
    
    func testEmptyRow()
    {
        let row: [TFENode?] = [nil, nil, nil, nil]
        
        let slid = slideRow(row)
        
        XCTAssertNil(slid)
    }
    
    func testBackwards()
    {
        let row: [TFENode?] = [TFENode(value: 2), TFENode(value: 4), TFENode(value: 8), TFENode(value: 16)]
        
        let slid = slideRow(row)
        
        XCTAssertNil(slid)
    }
    
    func testForwards()
    {
        let row: [TFENode?] = [TFENode(value: 16), TFENode(value: 8), TFENode(value: 4), TFENode(value: 2)]
        
        let slid = slideRow(row)
        
        XCTAssertNil(slid)
    }
    
    //MARK: - Combinations
    
    func testSplitWithTailerCombo()
    {
        let node = TFENode(value: 2)
        let row: [TFENode?] = [node, nil, node, node]
        let expected = [SlidTile(node, node), SlidTile(node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testLoneMidCombo()
    {
        let node = TFENode(value: 2)
        let row: [TFENode?] = [nil, node, node, nil]
        let expected = [SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testEndCapMidCombo()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 256)
        let row: [TFENode?] = [largeNode, node, node, nil]
        let expected = [SlidTile(largeNode), SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testFarEndCombo()
    {
        let node = TFENode(value: 2)
        let row: [TFENode?] = [nil, nil, node, node]
        let expected = [SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testDoubleHeaderCombo()
    {
        let node = TFENode(value: 4)
        let largeNode = TFENode(value: 8)
        let row: [TFENode?] = [node, node, largeNode, node]
        let expected = [SlidTile(node, node), SlidTile(largeNode), SlidTile(node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testDoubleDoubleCombo()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 8)
        let row: [TFENode?] = [node, node, largeNode, largeNode]
        let expected = [SlidTile(node, node), SlidTile(largeNode, largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testQuadCombo()
    {
        let node = TFENode(value: 4)
        let row: [TFENode?] = [node, node, node, node]
        let expected = [SlidTile(node, node), SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    //MARK: - Sliding
    
    func testMiddleSlide()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 4)
        let row: [TFENode?] = [nil, node, largeNode, nil]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testForwardSplitSlide()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 4)
        let row: [TFENode?] = [node, nil, largeNode, nil]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testRearwardSplitSlide()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 4)
        let row: [TFENode?] = [nil, node, nil, largeNode]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testRearwardSlide()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 4)
        let row: [TFENode?] = [nil, nil, node, largeNode]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testThreeRearwardSlide()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 256)
        let otherNode = TFENode(value: 4)
        let row: [TFENode?] = [nil, largeNode, node, otherNode]
        let expected = [SlidTile(largeNode), SlidTile(node), SlidTile(otherNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testThreeSplitSlide()
    {
        let node = TFENode(value: 2)
        let largeNode = TFENode(value: 256)
        let otherNode = TFENode(value: 4)
        let row: [TFENode?] = [largeNode, nil, node, otherNode]
        let expected = [SlidTile(largeNode), SlidTile(node), SlidTile(otherNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
}

