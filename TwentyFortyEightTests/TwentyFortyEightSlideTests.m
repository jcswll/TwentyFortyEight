//
//  TwentyFortyEightTests.m
//  TwentyFortyEightTests
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFE.h"
#import "TFETestHeader.h"
#import "TFENode.h"

@interface TwentyFortyEightSlideTests : XCTestCase

@end

@implementation TwentyFortyEightSlideTests

#pragma mark - No movement

- (void)testEmptyRow
{
    NSArray * row = @[[NSNull null],
                      [NSNull null],
                      [NSNull null],
                      [NSNull null]];
    
    NSArray * slid = TFESlideRow(row);
    
    XCTAssertNil(slid);
}

- (void)testBackwards
{
    NSArray * row = @[[TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:8],
                      [TFENode nodeWithValue:16]];
    
    NSArray * slid = TFESlideRow(row);
    
    XCTAssertNil(slid);
}

- (void)testForwards
{
    NSArray * row = @[[TFENode nodeWithValue:16],
                      [TFENode nodeWithValue:8],
                      [TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:2]];
    
    NSArray * slid = TFESlideRow(row);

    XCTAssertNil(slid);
}

#pragma mark - Combination

- (void)testSplitWithTailerCombo
{
    NSArray * row = @[[TFENode nodeWithValue:2],
                      [NSNull null],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:2]];
    
    NSArray * slid = TFESlideRow(row);
    
    NSArray * expected = @[@[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]],
                           [TFENode nodeWithValue:2]];
    
    XCTAssertEqualObjects(slid, expected);
}

- (void)testLoneMidCombo
{
    NSArray * row = @[[NSNull null],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:2],
                      [NSNull null]];
    
    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[@[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]]];
    
    XCTAssertEqualObjects(slid, expected);
}

- (void)testEndCapMidCombo
{
    NSArray * row = @[[TFENode nodeWithValue:256],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:2],
                      [NSNull null]];
    
    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[[TFENode nodeWithValue:256],
                           @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]]];
    
    XCTAssertEqualObjects(slid, expected);
}

- (void)testFarEndCombo
{
    NSArray * row = @[[NSNull null], [NSNull null],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:2]];
    
    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[@[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]]];
    
    XCTAssertEqualObjects(slid, expected);
}

- (void)testDoubleHeaderCombo
{
    NSArray * row = @[[TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:8],
                      [TFENode nodeWithValue:4]];
    
    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[@[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]],
                           [TFENode nodeWithValue:8],
                           [TFENode nodeWithValue:4]];

    XCTAssertEqualObjects(slid, expected);
}

- (void)testDoubleDoubleCombo
{
    NSArray * row = @[[TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:8],
                      [TFENode nodeWithValue:8]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[@[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]],
                           @[[TFENode nodeWithValue:8], [TFENode nodeWithValue:8]]];

    XCTAssertEqualObjects(slid, expected);
}

- (void)testQuadCombo
{
    NSArray * row = @[[TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:4],
                      [TFENode nodeWithValue:4]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[@[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]],
                           @[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]]];

    XCTAssertEqualObjects(slid, expected);
}

#pragma mark - Just sliding

- (void)testMiddleSlide
{
    NSArray * row = @[[NSNull null],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:4],
                      [NSNull null]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];

    XCTAssertEqualObjects(slid, expected);
}

- (void)testForwardSplitSlide
{
    NSArray * row = @[[TFENode nodeWithValue:2],
                      [NSNull null],
                      [TFENode nodeWithValue:4],
                      [NSNull null]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];

    XCTAssertEqualObjects(slid, expected);
}

- (void)testRearwardSplitSlide
{
    NSArray * row = @[[NSNull null],
                      [TFENode nodeWithValue:2],
                      [NSNull null],
                      [TFENode nodeWithValue:4]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];

    XCTAssertEqualObjects(slid, expected);
}

- (void)testRearwardSlide
{
    NSArray * row = @[[NSNull null],
                      [NSNull null],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:4]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];

    XCTAssertEqualObjects(slid, expected);
}

- (void)testThreeRearwardSlide
{
    NSArray * row = @[[NSNull null],
                      [TFENode nodeWithValue:128],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:4]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[[TFENode nodeWithValue:128],
                           [TFENode nodeWithValue:2],
                           [TFENode nodeWithValue:4]];

    XCTAssertEqualObjects(slid, expected);
}

- (void)testThreeSplitSlide
{
    NSArray * row = @[[TFENode nodeWithValue:1024],
                      [NSNull null],
                      [TFENode nodeWithValue:2],
                      [TFENode nodeWithValue:4]];

    NSArray * slid = TFESlideRow(row);
    NSArray * expected = @[[TFENode nodeWithValue:1024],
                           [TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];

    XCTAssertEqualObjects(slid, expected);
}

@end
