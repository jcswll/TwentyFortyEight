//
//  TFELabel.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#if os(OSX)

import Cocoa

class TFELabel : NSTextField
{
    var text: String {
        
        get {
            return self.stringValue
        }
        
        set {
            self.stringValue = newValue
        }
    }
}

#else
    
import UIKit
    
class TFELabel : UILabel {}
    
#endif
