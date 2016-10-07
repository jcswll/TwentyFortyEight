//
//  Set+RandomInt.swift
//  SwifTFE
//
//  Created by Joshua Caswell on 4/12/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import Foundation

extension Set where Element : IntegerType {
    
    /** Return a random element from a set of integers. */
    func randomInt() -> Element?
    {
        var retVal = self.first
        
        for (i, v) in self.dropFirst().enumerate() {
            if 0 == arc4random_uniform(UInt32(i+2)) {
                retVal = v
            }
        }
        
        return retVal
    }
}
