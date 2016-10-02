//
//  TFEAppDelegate.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import Cocoa
import SpriteKit

@NSApplicationMain
class TFEAppDelegate : NSObject, NSApplicationDelegate
{
    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var mainView: SKView!
    
    var gameController: TFEGameController!
    
    func applicationDidFinishLaunching(_: Notification)
    {
        let controller = TFEGameController()
        self.gameController = controller
        
        self.mainWindow.contentViewController = controller
        self.mainWindow.makeFirstResponder(controller)
        
        self.mainWindow.makeKeyAndOrderFront(self)
    }
}
