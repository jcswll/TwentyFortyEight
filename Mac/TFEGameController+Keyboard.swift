//
//  TFEGameController+Keyboard.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/2/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import Cocoa
// Include Carbon for key code enum
import Carbon

extension TFEGameController
{
    override func keyDown(with event: NSEvent)
    {
        let keyCode = Int(event.keyCode)
        let modifierKeys = event.modifierFlags.intersection(NSDeviceIndependentModifierFlagsMask)
        
        if NSEventModifierFlags.control == modifierKeys && kVK_ANSI_S == keyCode {
            self.scene.toggleSlowForDebug()
            return
        }
        
        // Don't accept move input while movement is already taking place. Otherwise nodes get lost.
        guard self.scene.canAcceptInput else {
            return
        }
        
        let direction: SlideDirection
        switch keyCode {
            
            case kVK_ANSI_A, kVK_LeftArrow:
                direction = .left;
            case kVK_ANSI_W, kVK_UpArrow:
                direction = .up;
            case kVK_ANSI_D, kVK_RightArrow:
                direction = .right;
            case kVK_ANSI_S, kVK_DownArrow:
                direction = .down;
            default:
                // No movement for other keys
                return;
        }
        
        self.userDidInput(direction)
    }
}
