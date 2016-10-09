//
//  TFEViewController.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#if os(OSX)

import Cocoa

class TFEViewController : NSViewController
{    
    override func viewWillAppear()
    {
        self.viewWillAppear(false)
    }
    
    func viewWillAppear(_ animated: Bool)
    {
        return
    }
}

#else
    
import UIKit

class TFEViewController : UIViewController {}
    
#endif
