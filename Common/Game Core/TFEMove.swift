//
//  TFEMove.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/3/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

struct TFEMove
{
    let node: TFENode
    let destination: Int
    let isCombination: Bool
    let isSpawn: Bool
    
    init(node: TFENode, destination: Int, isCombination: Bool = false, isSpawn: Bool = false)
    {
        self.node = node
        self.destination = destination
        self.isCombination = isCombination
        self.isSpawn = isSpawn
    }
}
