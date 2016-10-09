//
//  SlidNode.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

/**
 * Representation of a node while they are being slid along a row.
 * The node can be in one of three states: Empty, Solo, or Combined. Combined
 * squares are made from two adjacent nodes that have the same value.
 *
 * The nodes themselves are stored in the associated values.
 */
enum SlidNode
{
    case combined(TFENode, TFENode)
    case solo(TFENode)
    case empty
    
    init(_ node: TFENode? = nil)
    {
        if let soloNode = node {
            self = .solo(soloNode)
        }
        else {
            self = .empty
        }
    }
    
    init(_ first: TFENode, _ second: TFENode)
    {
        self = .combined(first, second)
    }
}

/* SlidNode conforms to Equatable so that arrays of them can be compared. */
func ==(left: SlidNode, right: SlidNode) -> Bool
{
    switch (left, right) {
        
        case let (.solo(leftNode), .solo(rightNode)) where leftNode == rightNode:
            return true
        case let (.combined(leftNode), .combined(rightNode)) where leftNode == rightNode:
            return true
        case (.empty, .empty):
            return true
        default:
            return false
    }
}

extension SlidNode : Equatable {}
