//
//  TwentyFortyEightTests.m
//  TwentyFortyEightTests
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFENode.h"

@interface TwentyFortyEightTests : XCTestCase

@end

@implementation TwentyFortyEightTests

//#pragma mark - No movement
//
//- (void)testEmptyRow
//{
//    BOOL didMove;
//    NSArray * slid = slideRow(@[[NSNull null],
//                                [NSNull null],
//                                [NSNull null],
//                                [NSNull null]], &didMove);
//    XCTAssertFalse(didMove);
//    XCTAssertEqualObjects(slid, @[]);
//}
//
//- (void)testBackwards
//{
//    NSArray * row = @[[TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:8],
//                      [TFENode nodeWithValue:16]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    XCTAssertFalse(didMove);
//    XCTAssertEqualObjects(slid, row);
//}
//
//- (void)testForwards
//{
//    NSArray * row = @[[TFENode nodeWithValue:16],
//                      [TFENode nodeWithValue:8],
//                      [TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:2]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    XCTAssertFalse(didMove);
//    XCTAssertEqualObjects(slid, row);
//}
//
//#pragma mark - Combination
//
//- (void)testSplitWithTailerCombo
//{
//    NSArray * row = @[[TFENode nodeWithValue:2],
//                      [NSNull null],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:2]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[@[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]],
//                           [TFENode nodeWithValue:2]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testLoneMidCombo
//{
//    NSArray * row = @[[NSNull null],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:2],
//                      [NSNull null]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[@[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testEndCapMidCombo
//{
//    NSArray * row = @[[TFENode nodeWithValue:256],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:2],
//                      [NSNull null]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[[TFENode nodeWithValue:256],
//                           @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testFarEndCombo
//{
//    NSArray * row = @[[NSNull null], [NSNull null],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:2]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[@[[TFENode nodeWithValue:2], [TFENode nodeWithValue:2]]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testDoubleHeaderCombo
//{
//    NSArray * row = @[[TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:8],
//                      [TFENode nodeWithValue:4]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[@[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]],
//                           [TFENode nodeWithValue:8],
//                           [TFENode nodeWithValue:4]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testDoubleDoubleCombo
//{
//    NSArray * row = @[[TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:8],
//                      [TFENode nodeWithValue:8]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[@[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]],
//                           @[[TFENode nodeWithValue:8], [TFENode nodeWithValue:8]]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testQuadCombo
//{
//    NSArray * row = @[[TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:4],
//                      [TFENode nodeWithValue:4]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[@[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]],
//                           @[[TFENode nodeWithValue:4], [TFENode nodeWithValue:4]]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//#pragma mark - Just sliding
//
//- (void)testMiddleSlide
//{
//    NSArray * row = @[[NSNull null],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:4],
//                      [NSNull null]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testForwardSplitSlide
//{
//    NSArray * row = @[[TFENode nodeWithValue:2],
//                      [NSNull null],
//                      [TFENode nodeWithValue:4],
//                      [NSNull null]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testRearwardSplitSlide
//{
//    NSArray * row = @[[NSNull null],
//                      [TFENode nodeWithValue:2],
//                      [NSNull null],
//                      [TFENode nodeWithValue:4]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testRearwardSlide
//{
//    NSArray * row = @[[NSNull null],
//                      [NSNull null],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:4]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[[TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testThreeRearwardSlide
//{
//    NSArray * row = @[[NSNull null],
//                      [TFENode nodeWithValue:128],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:4]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[[TFENode nodeWithValue:128],
//                           [TFENode nodeWithValue:2],
//                           [TFENode nodeWithValue:4]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}
//
//- (void)testThreeSplitSlide
//{
//    NSArray * row = @[[TFENode nodeWithValue:1024],
//                      [NSNull null],
//                      [TFENode nodeWithValue:2],
//                      [TFENode nodeWithValue:4]];
//    BOOL didMove;
//    NSArray * slid = slideRow(row, &didMove);
//    NSArray * expected = @[[TFENode nodeWithValue:1024],
//                           [TFENode nodeWithValue:2], [TFENode nodeWithValue:4]];
//    XCTAssertTrue(didMove);
//    XCTAssertEqualObjects(slid, expected);
//}

@end
