//
//  PlayState.swift
//  Copyright © 2018 iFiero. All rights reserved.

import SpriteKit
import GameplayKit

class PlayState:GKState {
    unowned let scene:GameScene
    
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
        print("Play State")
    }
    /// 前一State是WaitState
    override func didEnter(from previousState: GKState?) {
       scene.runBall()
       scene.runBallRotate()
       scene.learnTemp.isHidden  = true
       scene.playButtonTemp.isHidden = true
    }
 
    /// 下一State是GameOver
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type
    }
    /// update 用于判断球的速度是否过快，如果太快了则设置linearDamping的阻力
    override func update(deltaTime seconds: TimeInterval) {
        scene.verifyBallSpeed(seconds)
        if scene.isGameWon() {
            print("win") // gameOver
            scene.runBallInvincible()
            scene.gameOver()
            
        }else {
            print("playing")
        }
    }
    
}

