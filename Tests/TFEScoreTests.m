//
//  TFEScoreTests.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 3/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TFE.h"
#import "TFETestHeader.h"
#import "TFENode.h"
#import "TileMove.h"

@interface TFEScoreTests : XCTestCase

@end

@implementation TFEScoreTests

- (void)testEmptyMove
{
    NSArray * moves = @[];
    uint32_t score = TFEScoreForMoves(moves);
    
    XCTAssertEqual(0, score);
}

- (void)testComboFours
{
    NSArray * moves = @[[TileMove moveForNode:[TFENode nodeWithValue:4]
                                    toSquare:0
                                   combining:YES
                                    spawning:NO],
                        [TileMove moveForNode:[TFENode nodeWithValue:4]
                                    toSquare:0
                                   combining:YES
                                    spawning:NO]];
    uint32_t score = TFEScoreForMoves(moves);
    
    XCTAssertEqual(8, score);
}

- (void)testOnlySpawn
{
    NSArray * moves = @[[TileMove moveForNode:[TFENode nodeWithValue:1024]
                                    toSquare:0
                                   combining:NO
                                    spawning:YES]];
    uint32_t score = TFEScoreForMoves(moves);

    XCTAssertEqual(0, score);
}

- (void)testDoubleCombo
{
    NSArray * moves = @[[TileMove moveForNode:[TFENode nodeWithValue:4]
                                    toSquare:0
                                   combining:YES
                                    spawning:NO],
                        [TileMove moveForNode:[TFENode nodeWithValue:4]
                                    toSquare:0
                                   combining:YES
                                    spawning:NO],
                        [TileMove moveForNode:[TFENode nodeWithValue:8]
                                    toSquare:0
                                   combining:YES
                                    spawning:NO],
                        [TileMove moveForNode:[TFENode nodeWithValue:8]
                                    toSquare:0
                                   combining:YES
                                    spawning:NO]];
    uint32_t score = TFEScoreForMoves(moves);
    
    XCTAssertEqual(24, score);
}

- (void)testNoCombos
{
    NSArray * moves = @[[TileMove moveForNode:[TFENode nodeWithValue:1204]
                                    toSquare:0
                                   combining:NO
                                    spawning:NO],
                        [TileMove moveForNode:[TFENode nodeWithValue:32]
                                    toSquare:1
                                   combining:NO
                                    spawning:NO],
                        [TileMove moveForNode:[TFENode nodeWithValue:64]
                                    toSquare:2
                                   combining:NO
                                    spawning:NO]];
    
    uint32_t score = TFEScoreForMoves(moves);
    
    XCTAssertEqual(0, score);
}

@end
