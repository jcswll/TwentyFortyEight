//
//  TestTile.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/10/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import protocol TFE.Tile

struct TestTile : TFE.Tile
{
    let value: Int
}

func ==(lhs: TestTile, rhs: TestTile) -> Bool
{
    return lhs.value == rhs.value
}
