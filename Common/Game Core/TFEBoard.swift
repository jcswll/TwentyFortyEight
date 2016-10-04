//
//  TFEBoard.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/2/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

struct TFEBoard
{
    private let controller: TFEGameController
    private let scene: TFEMainScene
    
    private var grid: [AnyObject]
    private var score: UInt32
    
    init(controller: TFEGameController, scene: TFEMainScene)
    {
        self.controller = controller
        self.scene = scene
        self.score = 0
        
        var initialSpawns: NSArray?
        self.grid = TFEBuildGrid(&initialSpawns)
        
        initialSpawns?.forEach { (spawn) in
            self.executeSpawn(spawn as! TFEMove)
        }
    }
    
    mutating func moveNodes(inDirection direction: TFENodeDirection)
    {
        guard direction != .NotADirection else {
            return
        }
        
        var possibleMoves: NSArray? = nil
        self.grid = TFEMoveNodesInDirection(self.grid, direction, &possibleMoves)
        
        guard let moves = possibleMoves as? [TFEMove] else {
            return
        }
        
        self.executeMoves(moves)
        self.score(moves)
        
        var spawn: TFEMove?
        self.grid = TFESpawnNewNodeExcludingDirection(self.grid, direction, &spawn)
        
        self.executeSpawn(spawn!)
        
        self.checkForEndGame()
    }
    
    func executeSpawn(spawn: TFEMove)
    {
        self.scene.spawnNode(spawn.node, inSquare: spawn.destination)
    }
    
    func executeMoves(moves: [TFEMove])
    {
        moves.filter({ $0.isSpawn }).forEach { spawn in
            self.executeSpawn(spawn)
        }
        moves.filter({ !$0.isSpawn }).forEach { move in
            self.scene.move(move.node, toSquare: move.destination, combining: move.isCombination)
        }
    }
    
    mutating func score(moves: [TFEMove])
    {
        let newPoints = TFEScoreForMoves(moves)
        guard newPoints > 0 else {
            return
        }
        
        self.score += newPoints
        self.controller.updateScore(to: self.score)
    }
    
    func checkForEndGame()
    {
        if TFEIsAWinner(self.grid) {
            self.controller.gameDidEnd(inVictory: true)
        }
        else if TFEIsALoser(self.grid) {
            self.controller.gameDidEnd(inVictory: false)
        }
    }
}
