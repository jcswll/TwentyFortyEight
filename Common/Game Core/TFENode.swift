//
//  TFENode.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/3/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import SpriteKit

/**
 * TFENodes are the sprites representing the tiles on the game board. They configure their appearance
 * and perform necessary animations. They also hold their point value, which the game engine uses to
 * calculate combinations.
 */
class TFENode : SKSpriteNode
{
    /** Create the appropriate `SKTexture` for this value. */
    private static func texture(forValue value: Int) -> SKTexture
    {
        return SKTexture(imageNamed: "\(value)")
    }
    
    /** The node's point value. This is a `TFENode`'s sole feature for purposes of comparison to other nodes. */
    let value: Int
    
    init(value: Int)
    {
        self.value = value
        
        let texture = TFENode.texture(forValue: value)
        super.init(texture: texture, color: SKColor.clear, size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is unimplemented")
    }
    
    /** Random duration for the grow or shrink/fade animation. */
    private var resizeFadeDuration: Double
    {
        let kResizeFadeDuration: Double = 0.19
        let gamut: Double = 0.08
        let offset = randomOffset(withGamut: gamut)
        
        return kResizeFadeDuration + offset
    }

    /** Random duration for each of the parts of the size bounce animation when spawning. */
    private var bounceDuration: Double
    {
        let kBounceDuration: Double = 0.06
        let gamut: Double = 0.08
        let offset = randomOffset(withGamut: gamut)
        
        return kBounceDuration + offset
    }

    /** Random duration for a slide animation. */
    private var moveDuration: Double
    {
        let kMoveDuration: Double = 0.125
        let gamut: Double = 0.08
        let offset = randomOffset(withGamut: gamut)
        
        return kMoveDuration + offset
    }
    
    /** Create node at the given position, with animation. */
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
        let grow = SKAction.scale(to: kUnityScale, duration: thisResizeDuration)
        
        // Do a little size bounce
        let scaleUp = SKAction.scale(to: kBounceUpperScale, duration: thisBounceDuration)
        let scaleDown = SKAction.scale(to: kBounceLowerScale, duration: thisBounceDuration)
        let scaleBackUp = SKAction.scale(to: kUnityScale, duration: thisBounceDuration)
        let bounce = SKAction.sequence([scaleUp, scaleDown, scaleBackUp])
        
        let spawn = SKAction.sequence([grow, bounce])
        
        self.position = position
        self.run(spawn)
    }
    
    /** Slide the node to the given position. */
    func move(toPosition destination: CGPoint)
    {
        self.move(toPosition: destination, duration: self.moveDuration)
    }
    
    /** Animate the node's dissappearance at the destination point. */
    func moveIntoCombination(atPosition destination: CGPoint)
    {
        let kFinalShrinkScale: CGFloat = 0.25
        
        let isChangingPosition = destination != self.position
        
        let thisResizeDuration = self.resizeFadeDuration
        
        let shrink = SKAction.scale(to: kFinalShrinkScale, duration: thisResizeDuration)
        let fade = SKAction.fadeOut(withDuration: thisResizeDuration)
        
        var fadeAndShrink = SKAction.group([shrink, fade])
        
        if isChangingPosition {
            
            let thisMoveDuration = self.moveDuration
            fadeAndShrink = SKAction.sequence([SKAction.wait(forDuration: thisMoveDuration), fadeAndShrink])
            self.move(toPosition: destination, duration: thisMoveDuration)
        }
        
        self.run(fadeAndShrink, completion: {
            
            // Next run loop
            DispatchQueue.main.async {
                self.removeFromParent()
            }
        })
    }
    
    /** Slide the node to the given position over the given duration. */
    private func move(toPosition destination: CGPoint, duration: TimeInterval)
    {
        let move = SKAction.move(to: destination, duration: duration)
        move.timingMode = .easeInEaseOut
        
        TFENode.movementDispatchGroup.enter()
        self.run(move, completion: {
            TFENode.movementDispatchGroup.leave()
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
        _ = self.movementDispatchGroup.wait(timeout: .distantFuture)
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
        return .success != self.movementDispatchGroup.wait(timeout: .now())
    }
    
    /**
     * The TFENode class tracks whether any instances are running animations.
     * This dispatch group is the means. An instance enters the group before
     * starting its animation action, and leaves the group in the action's
     * completion.
     */
    fileprivate static let movementDispatchGroup = DispatchGroup()
}
