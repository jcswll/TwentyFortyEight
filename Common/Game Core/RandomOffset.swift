//
//  RandomOffset.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import Foundation

/** Choose a random number between -gamut/2 and gamut/2 */
func randomOffset(withGamut gamut: Double) -> Double
{
    let randVal = Double(arc4random() / UInt32.max)
    return gamut * randVal - (gamut / 2)
}
