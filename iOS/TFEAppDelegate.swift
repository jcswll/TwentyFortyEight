//
//  TFEAppDelegate.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class TFEAppDelegate : NSObject, UIApplicationDelegate
{
    var mainWindow: UIWindow!
    
    var gameController: TFEGameController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let window = UIWindow()
        let controller = TFEGameController()

        self.mainWindow = window
        self.gameController = controller

        self.mainWindow.rootViewController = controller
        
        self.mainWindow.makeKeyAndVisible()
        
        return true
    }
}
