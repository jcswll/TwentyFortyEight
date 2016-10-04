//
//  TFEGameController.swift
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 10/1/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

import SpriteKit

class TFEGameController : TFEViewController
{
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var scoreLabel: TFELabel!
    
    let scene: TFEMainScene
    private(set) var board: TFEBoard!
    
    private var _score: UInt32 = 0
    
    init()
    {
        self.scene = TFEMainScene(size: CGSizeMake(100, 100))
        
        #if os(OSX)
        super.init(nibName: "MainView", bundle: nil)!
        #elseif os(iOS)
        super.init(nibName: "MainView", bundle: nil)
        #endif
        
        self.board = TFEBoard(controller: self, scene: self.scene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unimplemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.scene.size = self.gameView.bounds.size
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.gameView.presentScene(self.scene)
    }
    
    override func becomeFirstResponder() -> Bool
    {
        return true
    }
    
    // Message sent to self from platform-specific user input extensions.
    // This is necessary because `board` is not mutable inside the extensions, and `moveNodes(inDirection:)` is mutating.
    func userDidInput(direction: TFENodeDirection)
    {
        self.board.moveNodes(inDirection: direction)
    }
    
    //MARK: - Communication from board
    
    func gameDidEnd(inVictory victorious: Bool)
    {
        self.scene.gameDidEnd(inVictory: victorious)
    }
    
    func updateScore(to score: UInt32)
    {
        self.scoreLabel.text = String(format: "%d", score)
    }
}
