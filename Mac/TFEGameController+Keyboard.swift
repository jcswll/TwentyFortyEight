//
//  TFEGameController+Keyboard.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/2/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

// Include Carbon for key code enum
import Carbon

extension TFEGameController
{
    override func keyDown(theEvent: NSEvent)
    {
        let keyCode = Int(theEvent.keyCode)
        let modifierKeys = theEvent.modifierFlags.intersect(NSDeviceIndependentModifierFlagsMask)
        
        if NSEventModifierFlags.Control == modifierKeys && kVK_ANSI_S == keyCode {
            self.scene.toggleSlowForDebug()
            return
        }
        
        // Don't accept move input while movement is already taking place. Otherwise nodes get lost.
        guard self.scene.canAcceptInput() else {
            return
        }
        
        let direction: TFENodeDirection
        switch keyCode {
            
            case kVK_ANSI_A, kVK_LeftArrow:
                direction = .Left;
            case kVK_ANSI_W, kVK_UpArrow:
                direction = .Up;
            case kVK_ANSI_D, kVK_RightArrow:
                direction = .Right;
            case kVK_ANSI_S, kVK_DownArrow:
                direction = .Down;
            default:
                // No movement for other keys
                return;
        }
        
        self.userDidInput(direction)
    }
}
