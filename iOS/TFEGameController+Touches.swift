//
//  TFEGameController+Touches.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/3/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import UIKit

extension TFEGameController
{
    func swipe(_ recognizer: UISwipeGestureRecognizer)
    {
        // Don't accept swipe input while movement is taking place. Otherwise nodes get lost.
        guard self.scene.canAcceptInput else {
            return
        }
        
        let swipeDirection = recognizer.direction
        let nodeDirection: SlideDirection
        
        switch swipeDirection {
            
            case UISwipeGestureRecognizerDirection.left:
                nodeDirection = .left
            case UISwipeGestureRecognizerDirection.up:
                nodeDirection = .up
            case UISwipeGestureRecognizerDirection.right:
                nodeDirection = .right
            case UISwipeGestureRecognizerDirection.down:
                nodeDirection = .down
            default:
                return
        }
        
        self.userDidInput(nodeDirection)
    }
    
    func longPress(_ recognizer: UILongPressGestureRecognizer)
    {
        guard recognizer.state == .began else {
            return
        }
        
        self.scene.toggleSlowForDebug()
    }
}
