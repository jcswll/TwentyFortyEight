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
    
    override func didMove(to _: SKView)
    {
        self.backgroundColor = TFEMainScene.whiteColor
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
    
    func move(_ node: TFENode, toSquare square: Int, combining: Bool)
    {
        let destination = self.center(ofGridSquare: square)
        
        if combining {
            node.moveIntoCombination(atPosition: destination)
        }
        else {
            node.move(toPosition: destination)
        }
    }
    
    func spawn(_ node: TFENode, inSquare square: Int)
    {
        let wait_queue = DispatchQueue.global(qos: .default)//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let ui_queue = DispatchQueue.main

        wait_queue.async {
            
            TFENode.waitOnAllNodeMovement()
            ui_queue.async {
                
                self.addChild(node)
                node.size = CGSize(width: self.nodeSize, height: self.nodeSize)
                node.spawn(atPosition: self.center(ofGridSquare: square))
            }
        }
    }
    
    func gameDidEnd(inVictory victorious: Bool)
    {
        let message = victorious ? "You won!" : "Game over"

        let label = SKLabelNode(fontNamed: "Krungthep")
        label.fontColor = TFEMainScene.blackColor
        label.fontSize = 108
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        label.text = message
        
        let wait_queue = DispatchQueue.global(qos: .default)
        let ui_queue = DispatchQueue.main

        wait_queue.async {
            
            TFENode.waitOnAllNodeMovement()
            
            let delay = DispatchTime.now() + .seconds(1)
            ui_queue.asyncAfter(deadline: delay) {
                
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
    
    // Not marked private to allow unit testing raw calculation
    func center(ofGridSquare squareNumber: Int) -> CGPoint
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
