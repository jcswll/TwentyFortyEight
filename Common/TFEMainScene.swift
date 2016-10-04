//
//  TFEMainScene.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/3/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import SpriteKit

class TFEMainScene : SKScene
{
    private static var whiteColor: SKColor {
        return SKColor(red: 243.0/255, green: 242.0/255, blue: 230.0/255, alpha: 1.0)
    }
    private static var blackColor: SKColor {
        return SKColor(red: 33.0/255, green: 30.0/255, blue: 0, alpha: 1.0)
    }
    
    /** Returns NO while node movement is taking place. */
    var canAcceptInput: Bool { return !TFENode.anyNodeMovementInProgress() }
    
    /** The side size for all the tile nodes in the scene. They are always square. */
    private var nodeSize: CGFloat = 100.0
    
    private var fullSpeed: Bool = true
    
    override func didMoveToView(_: SKView)
    {
        self.backgroundColor = self.dynamicType.whiteColor
        self.calculateNodeSize()
    }
    
    override func didChangeSize(_: CGSize)
    {
        self.calculateNodeSize()
    }
    
    func toggleSlowForDebug()
    {
        let fullSpeed = self.fullSpeed
        let newSpeed = fullSpeed ? 0.1 : 1.0
        
        self.fullSpeed = !fullSpeed
        self.speed = CGFloat(newSpeed)
    }
    
    //MARK: - Communication from board
    
    func move(node: TFENode, toSquare square: UInt, combining: Bool)
    {
        let destination = self.center(ofGridSquare: square)
        
        if combining {
            node.moveIntoCombination(atPosition: destination)
        }
        else {
            node.move(toPosition: destination)
        }
    }
    
    func spawnNode(node: TFENode, inSquare square: UInt)
    {
        let wait_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let ui_queue = dispatch_get_main_queue()

        dispatch_async(wait_queue, {
            
            TFENode.waitOnAllNodeMovement()
            dispatch_async(ui_queue, {
                
                self.addChild(node)
                node.size = CGSize(width: self.nodeSize, height: self.nodeSize)
                node.spawn(atPosition: self.center(ofGridSquare: square))
            })
        })
    }
    
    func gameDidEnd(inVictory victorious: Bool)
    {
        let message = victorious ? "You won!" : "Game over"

        let label = SKLabelNode(fontNamed: "Krungthep")
        label.fontColor = self.dynamicType.blackColor
        label.fontSize = 108
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        label.text = message
        
        let wait_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let ui_queue = dispatch_get_main_queue()

        dispatch_async(wait_queue) {
            
            TFENode.waitOnAllNodeMovement()
            
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
            dispatch_after(delay, ui_queue) {
                
                self.addChild(label)
            }
        }
    }
    
    //MARK: Private
    
    private func calculateNodeSize()
    {
        // Nodes will be inset from their grid square by (square_size / inset_factor) on all sides
        let kNodeSizeInsetFactor: CGFloat = 8.0
        
        let minDimension = min(self.size.width, self.size.height)
        let gridSquareSide = minDimension / 4
        
        self.nodeSize = gridSquareSide - (2 * gridSquareSide / kNodeSizeInsetFactor)
    }
    
    private func center(ofGridSquare squareNumber: UInt) -> CGPoint
    {
        let minDimension = min(self.size.width, self.size.height)
        let gridSquareSide = minDimension / 4
        let col = CGFloat(squareNumber % 4)
        let row = CGFloat(squareNumber / 4)
        let x = gridSquareSide * (col + 0.5)
        let y = gridSquareSide * (row + 0.5)
        
        return CGPoint(x: x, y: y)
    }
}
