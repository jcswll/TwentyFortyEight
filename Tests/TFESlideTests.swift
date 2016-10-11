//
//  TFESlideTests.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import XCTest
@testable import TFE

class TFESlideTests : XCTestCase
{
    //MARK: - No movement
    
    func testEmptyRow()
    {
        let row: [TestTile?] = [nil, nil, nil, nil]
        
        let slid = slideRow(row)
        
        XCTAssertNil(slid)
    }
    
    func testBackwards()
    {
        let row: [TestTile?] = [TestTile(value: 2), TestTile(value: 4), TestTile(value: 8), TestTile(value: 16)]
        
        let slid = slideRow(row)
        
        XCTAssertNil(slid)
    }
    
    func testForwards()
    {
        let row: [TestTile?] = [TestTile(value: 16), TestTile(value: 8), TestTile(value: 4), TestTile(value: 2)]
        
        let slid = slideRow(row)
        
        XCTAssertNil(slid)
    }
    
    //MARK: - Combinations
    
    func testSplitWithTailerCombo()
    {
        let node = TestTile(value: 2)
        let row: [TestTile?] = [node, nil, node, node]
        let expected = [SlidTile(node, node), SlidTile(node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testLoneMidCombo()
    {
        let node = TestTile(value: 2)
        let row: [TestTile?] = [nil, node, node, nil]
        let expected = [SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testEndCapMidCombo()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 256)
        let row: [TestTile?] = [largeNode, node, node, nil]
        let expected = [SlidTile(largeNode), SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testFarEndCombo()
    {
        let node = TestTile(value: 2)
        let row: [TestTile?] = [nil, nil, node, node]
        let expected = [SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testDoubleHeaderCombo()
    {
        let node = TestTile(value: 4)
        let largeNode = TestTile(value: 8)
        let row: [TestTile?] = [node, node, largeNode, node]
        let expected = [SlidTile(node, node), SlidTile(largeNode), SlidTile(node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testDoubleDoubleCombo()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 8)
        let row: [TestTile?] = [node, node, largeNode, largeNode]
        let expected = [SlidTile(node, node), SlidTile(largeNode, largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testQuadCombo()
    {
        let node = TestTile(value: 4)
        let row: [TestTile?] = [node, node, node, node]
        let expected = [SlidTile(node, node), SlidTile(node, node)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    //MARK: - Sliding
    
    func testMiddleSlide()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 4)
        let row: [TestTile?] = [nil, node, largeNode, nil]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testForwardSplitSlide()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 4)
        let row: [TestTile?] = [node, nil, largeNode, nil]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testRearwardSplitSlide()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 4)
        let row: [TestTile?] = [nil, node, nil, largeNode]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testRearwardSlide()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 4)
        let row: [TestTile?] = [nil, nil, node, largeNode]
        let expected = [SlidTile(node), SlidTile(largeNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testThreeRearwardSlide()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 256)
        let otherNode = TestTile(value: 4)
        let row: [TestTile?] = [nil, largeNode, node, otherNode]
        let expected = [SlidTile(largeNode), SlidTile(node), SlidTile(otherNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
    
    func testThreeSplitSlide()
    {
        let node = TestTile(value: 2)
        let largeNode = TestTile(value: 256)
        let otherNode = TestTile(value: 4)
        let row: [TestTile?] = [largeNode, nil, node, otherNode]
        let expected = [SlidTile(largeNode), SlidTile(node), SlidTile(otherNode)]
        
        let slid = slideRow(row)
        
        stopOnFailure{ XCTAssertNotNil(slid) }
        XCTAssertEqual(slid!, expected)
    }
}

