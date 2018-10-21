//
//  GameOverState.swift
//
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState:GKState {
    
    unowned let scene:GameScene
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        print("GameOver State 游戏结束")
        initGameOver()
        initWinLoseLogo(scene.isGameWon())
    }
    
    func initGameOver(){
        let xPos = scene.frame.size.width / 2
        let yPos = scene.frame.size.height / 2
        let tapNode = SKSpriteNode(imageNamed: "tapToPlay")
        tapNode.name = "tapToPlay"
        tapNode.position = CGPoint(x: xPos, y: yPos)
        tapNode.setScale(1.0)
        tapNode.zPosition = 6
        scene.addChild(tapNode)
    }
    
    func initWinLoseLogo(_ winorLose:Bool){
        let imageNamed = winorLose ? "youwon": "youlose"
        let xPos = scene.frame.size.width / 2
        let yPos = scene.frame.size.height / 2 + 150
        let tapNode = SKSpriteNode(imageNamed: imageNamed)
        tapNode.setScale(0.8)
        tapNode.name = "tapToPlay"
        tapNode.position = CGPoint(x: xPos, y: yPos)
        tapNode.setScale(1.0)
        tapNode.zPosition = 6
        scene.addChild(tapNode)
    }
    
//    
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        return stateClass is WaitingState.Type
//    }
}
