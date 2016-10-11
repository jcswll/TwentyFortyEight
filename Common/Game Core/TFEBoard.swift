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
        
        let initialSpawns: [TileMove<TFENode>]
        (initialSpawns, self.grid) = TFEBuildGrid()
        
        for spawn in initialSpawns {
            self.executeSpawn(spawn)
        }
    }
    
    mutating func moveNodes(inDirection direction: SlideDirection)
    {
        let possibleMoves: [TileMove<TFENode>]?
        (possibleMoves, self.grid) = TFEMoveTiles(self.grid, inDirection: direction)
        
        guard let moves = possibleMoves else {
            return
        }
        
        self.executeMoves(moves)
        self.score(moves)
        
        let spawn: TileMove<TFENode>
        (spawn, self.grid) = TFESpawnNewTile(on: self.grid, excluding: direction)
        
        self.executeSpawn(spawn)
        
        self.checkForEndGame()
    }
    
    func executeSpawn(_ spawn: TileMove<TFENode>)
    {
        self.scene.spawn(spawn.tile, inSquare: spawn.destination)
    }
    
    func executeMoves(_ moves: [TileMove<TFENode>])
    {
        for spawn in moves.filter({ $0.isSpawn }) {
            self.executeSpawn(spawn)
        }
        for move in moves.filter({ !$0.isSpawn }) {
            self.scene.move(move.tile, toSquare: move.destination, combining: move.isCombination)
        }
    }
    
    mutating func score(_ moves: [TileMove<TFENode>])
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
