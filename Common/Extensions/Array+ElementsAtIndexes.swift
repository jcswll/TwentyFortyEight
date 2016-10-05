//
//  Array+ElementsAtIndexes.swift
//  SwifTFE
//
//  Created by Joshua Caswell on 4/12/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

extension Array
{
    /**
     * Given an array of integer indexes, return an array of the receiever's
     * elements at those indexes.
     */
    func elementsAtIndexes(indexes: [Int]) -> [Element]
    {
        var retVal: [Element] = []

        for index in indexes {
            retVal.append(self[index])
        }
        
        return retVal
    }
}
