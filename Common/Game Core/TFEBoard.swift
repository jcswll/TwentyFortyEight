//
//  TFEBoard.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/2/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import TFE

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
        
        let initialSpawns: [TFE.TileMove<TFENode>]
        (initialSpawns, self.grid) = TFE.buildGrid()
        
        for spawn in initialSpawns {
            self.executeSpawn(spawn)
        }
    }
    
    mutating func moveNodes(inDirection direction: SlideDirection)
    {
        let possibleMoves: [TFE.TileMove<TFENode>]?
        (possibleMoves, self.grid) = TFE.moveTiles(self.grid, inDirection: direction)
        
        guard let moves = possibleMoves else {
            return
        }
        
        self.executeMoves(moves)
        self.score(moves)
        
        let spawn: TFE.TileMove<TFENode>
        (spawn, self.grid) = TFE.spawnNewTile(on: self.grid, excluding: direction)
        
        self.executeSpawn(spawn)
        
        self.checkForEndGame()
    }
    
    func executeSpawn(_ spawn: TFE.TileMove<TFENode>)
    {
        self.scene.spawn(spawn.tile, inSquare: spawn.destination)
    }
    
    func executeMoves(_ moves: [TFE.TileMove<TFENode>])
    {
        for spawn in moves.filter({ $0.isSpawn }) {
            self.executeSpawn(spawn)
        }
        for move in moves.filter({ !$0.isSpawn }) {
            self.scene.move(move.tile, toSquare: move.destination, combining: move.isCombination)
        }
    }
    
    mutating func score(_ moves: [TFE.TileMove<TFENode>])
    {
        let newPoints = TFE.score(forMoves: moves)
        guard newPoints > 0 else {
            return
        }
        
        self.score += newPoints
        self.controller.updateScore(to: self.score)
    }
    
    func checkForEndGame()
    {
        if TFE.isAWinner(self.grid) {
            self.controller.gameDidEnd(inVictory: true)
        }
        else if TFE.isALoser(self.grid) {
            self.controller.gameDidEnd(inVictory: false)
        }
    }
}
