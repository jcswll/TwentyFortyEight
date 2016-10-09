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
    
    private var grid: [TFENode?]
    private var score: Int
    
    init(controller: TFEGameController, scene: TFEMainScene)
    {
        self.controller = controller
        self.scene = scene
        self.score = 0
        
        let initialSpawns: [TFEMove]
        (initialSpawns, self.grid) = TFEBuildGrid()
        
        for spawn in initialSpawns {
            self.executeSpawn(spawn)
        }
    }
    
    mutating func moveNodes(inDirection direction: TFENodeDirection)
    {        
        let possibleMoves: [TFEMove]?
        (possibleMoves, self.grid) = TFEMoveNodes(self.grid, inDirection: direction)
        
        guard let moves = possibleMoves else {
            return
        }
        
        self.executeMoves(moves)
        self.score(moves)
        
        let spawn: TFEMove
        (spawn, self.grid) = TFESpawnNewNode(on: self.grid, excluding: direction)
        
        self.executeSpawn(spawn)
        
        self.checkForEndGame()
    }
    
    func executeSpawn(_ spawn: TFEMove)
    {
        self.scene.spawn(spawn.node, inSquare: spawn.destination)
    }
    
    func executeMoves(_ moves: [TFEMove])
    {
        for spawn in moves.filter({ $0.isSpawn }) {
            self.executeSpawn(spawn)
        }
        for move in moves.filter({ !$0.isSpawn }) {
            self.scene.move(move.node, toSquare: move.destination, combining: move.isCombination)
        }
    }
    
    mutating func score(_ moves: [TFEMove])
    {
        let newPoints = TFEScore(forMoves: moves)
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
