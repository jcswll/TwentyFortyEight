//
//  GridSquarePositions.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/4/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

/**
 * The grid positions of the squares on the side of the grid away from the given direction.
 */
struct TrailingSquares
{
    private static let left: Set<Int> = [12, 8, 4, 0]
    private static let up: Set<Int> = [12, 13, 14, 15]
    private static let right: Set<Int> = [15, 11, 7, 3]
    private static let down: Set<Int> = [0, 1, 2, 3]
    
    static func awayFrom(direction: TFENodeDirection) -> Set<Int>
    {
        switch direction {
            
            case .Left:
                return self.left
            case .Up:
                return self.up
            case .Right:
                return self.right
            case .Down:
                return self.down
        }
    }
}

/**
 * Grid positions, by row, in the proper traversal order for sliding in a
 * given direction.
 *
 * The rows are presented from the left and top edge of the grid. The indexes
 * within each row are ordered so that the beginning of the array is the
 * direction of movement.
 */
struct GridIndexes
{
    private static let left = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15]]
    
    private static let up = [[12, 8, 4, 0], [13, 9, 5, 1], [14, 10, 6, 2], [15, 11, 7, 3]]

    private static let right = [[3, 2, 1, 0], [7, 6, 5, 4], [11, 10, 9, 8], [15, 14, 13, 12]]

    private static let down = [[0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15]]
        
    static func by(direction: TFENodeDirection) -> [[Int]]
    {
        switch direction {
            
            case .Left:
                return self.left
            case .Up:
                return self.up
            case .Right:
                return self.right
            case .Down:
                return self.down
        }
    }
}
