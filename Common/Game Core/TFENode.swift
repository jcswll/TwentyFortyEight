//
//  TFENode.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/3/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import SpriteKit

class TFENode : SKSpriteNode
{
    /** The node's point value. This is a `TFENode`'s sole feature for purposes of comparison to other nodes. */
    let value: UInt32
    
    init(value: UInt32)
    {
        self.value = value
        
        let texture = textureForValue(value)
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is unimplemented")
    }
    
    /** Random duration for the grow or shrink/fade animation. */
    private var resizeFadeDuration: Double {
        
        let kResizeFadeDuration: Double = 0.19
        let gamut: Double = 0.08
        let offset = randomOffset(withGamut: gamut)
        
        return kResizeFadeDuration + offset
    }

    /** Random duration for each of the parts of the size bounce animation when spawning. */
    private var bounceDuration: Double {
        
        let kBounceDuration: Double = 0.06
        let gamut: Double = 0.08
        let offset = randomOffset(withGamut: gamut)
        
        return kBounceDuration + offset
    }

    /** Random duration for a slide animation. */
    private var moveDuration: Double {
        
        let kMoveDuration: Double = 0.125
        let gamut: Double = 0.08
        let offset = randomOffset(withGamut: gamut)
        
        return kMoveDuration + offset
    }
    
    func spawn(atPosition position: CGPoint)
    {
        let kInitialScale: CGFloat = 0.85
        let kBounceUpperScale: CGFloat = 1.1
        let kBounceLowerScale: CGFloat = 0.93
        let kUnityScale: CGFloat = 1.0
        
        let thisResizeDuration = self.resizeFadeDuration
        let thisBounceDuration = self.bounceDuration
        
        // Grow to full size
        self.setScale(kInitialScale)
        let grow = SKAction.scaleTo(kUnityScale, duration: thisResizeDuration)
        
        // Do a little size bounce
        let scaleUp = SKAction.scaleTo(kBounceUpperScale, duration: thisBounceDuration)
        let scaleDown = SKAction.scaleTo(kBounceLowerScale, duration: thisBounceDuration)
        let scaleBackUp = SKAction.scaleTo(kUnityScale, duration: thisBounceDuration)
        let bounce = SKAction.sequence([scaleUp, scaleDown, scaleBackUp])
        
        let spawn = SKAction.sequence([grow, bounce])
        
        self.position = position
        self.runAction(spawn)
    }
    
    func move(toPosition destination: CGPoint)
    {
        self.move(toPosition: position, duration: self.moveDuration)
    }
    
    func moveIntoCombination(atPosition destination: CGPoint)
    {
        let kFinalShrinkScale: CGFloat = 0.25
        
        let changingPosition = destination != self.position
        
        let thisResizeDuration = self.resizeFadeDuration
        
        let shrink = SKAction.scaleTo(kFinalShrinkScale, duration: thisResizeDuration)
        let fade = SKAction.fadeOutWithDuration(thisResizeDuration)
        
        var fadeAndShrink = SKAction.group([shrink, fade])
        
        if changingPosition {
            
            let thisMoveDuration = self.moveDuration
            fadeAndShrink = SKAction.sequence([SKAction.waitForDuration(thisMoveDuration), fadeAndShrink])
            self.move(toPosition: destination, duration: thisMoveDuration)
        }
        
        self.runAction(fadeAndShrink, completion: {
            
            // Next run loop
            dispatch_async(dispatch_get_main_queue()) {
                self.removeFromParent()
            }
        })
    }
    
    private func move(toPosition destination: CGPoint, duration: NSTimeInterval)
    {
        let move = SKAction.moveTo(destination, duration: duration)
        move.timingMode = .EaseInEaseOut
        
        dispatch_group_enter(TFENode.movementDispatchGroup)
        self.runAction(move, completion: {
            dispatch_group_leave(TFENode.movementDispatchGroup)
        })
    }
}

//MARK: - Comparability
func ==(lhs: TFENode, rhs: TFENode) -> Bool
{
    return lhs.value == rhs.value
}

func <(lhs: TFENode, rhs: TFENode) -> Bool
{
    return lhs.value < rhs.value
}

extension TFENode : Comparable
{
    override var hashValue: Int { return super.hashValue << Int(self.value) }
}

//MARK: - Node movement tracking
extension TFENode
{
    /**
     * The TFENode class tracks whether any instances are running their "move" or
     * "spawn" animations in order to avoid overlapping creation and destruction
     * of moving nodes. `waitOnAllNodeMovement()` blocks when called until all
     * nodes have completed their animations.
     */
    class func waitOnAllNodeMovement()
    {
        dispatch_group_wait(self.movementDispatchGroup, DISPATCH_TIME_FOREVER)
    }
    
    /**
     * The TFENode class tracks whether any instances are running their "move" or
     * "spawn" animations. `anyNodeMovementInProgress()` returns immediately with a
     * boolean indicating whether any animations are currently running.
     */
    class func anyNodeMovementInProgress() -> Bool
    {
        // Return immediately regardless, but signal whether it was because
        // the group is inactive or because of timeout.
        return 0 != dispatch_group_wait(self.movementDispatchGroup, DISPATCH_TIME_NOW)
    }
    
    /**
     * The TFENode class tracks whether any instances are running animations.
     * This dispatch group is the means. An instance enters the group before
     * starting its animation action, and leaves the group in the action's
     * completion.
     */
    private static let movementDispatchGroup: dispatch_group_t = dispatch_group_create()
}

private func textureForValue(value: UInt32) -> SKTexture
{
    return SKTexture(imageNamed: "\(value)")
}

private func randomOffset(withGamut gamut: Double) -> Double
{
    let randVal = Double(arc4random() / UInt32.max)
    return gamut * randVal - (gamut / 2)
}
