//
//  TFEGameController+Touches.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/3/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

extension TFEGameController
{
    func swipe(recognizer: UISwipeGestureRecognizer)
    {
        // Don't accept swipe input while movement is taking place. Otherwise nodes get lost.
        guard self.scene.canAcceptInput() else {
            return
        }
        
        let swipeDirection = recognizer.direction
        let nodeDirection: TFENodeDirection
        
        switch swipeDirection {
            
            case UISwipeGestureRecognizerDirection.Left:
                nodeDirection = .Left
            case UISwipeGestureRecognizerDirection.Up:
                nodeDirection = .Up
            case UISwipeGestureRecognizerDirection.Right:
                nodeDirection = .Right
            case UISwipeGestureRecognizerDirection.Down:
                nodeDirection = .Down
            default:
                return
        }
        
        self.userDidInput(nodeDirection)
    }
    
    func longPress(recognizer: UILongPressGestureRecognizer)
    {
        guard recognizer.state == .Began else {
            return
        }
        
        self.scene.toggleSlowForDebug()
    }
}
