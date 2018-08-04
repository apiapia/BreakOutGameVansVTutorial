//
//  WaitingState.swift
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingState:GKState {
    
    unowned let scene:GameScene
    var playButton:SKSpriteNode!
    var learnTemp:SKSpriteNode!
    
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
        print("Waiting State")
    }
    //MARK: - 初始化PlayButton,但获得点击事件touchesBegan是在GameScene中进行判断;
    func initPlayButton() {
        /// 取得playButton节点
        playButton = scene.childNode(withName: "playButton") as! SKSpriteNode
        learnTemp = scene.childNode(withName: "learnTemp") as! SKSpriteNode
        learnTemp.name = "learnTemp"
        learnTemp.zPosition = 10 // 注意：位于Overlay的精灵上方
        playButton.isHidden = false
        /// 播放按钮的动画;
        let zoomOut = SKAction.scale(by: 0.8, duration: 0.75)
        zoomOut.timingMode = .easeInEaseOut
        let zoomIn  = zoomOut.reversed()
        zoomIn.timingMode  = .easeInEaseOut
        /// 播放顺序
        let sequence = SKAction.sequence([zoomOut,zoomIn])
        let repeatAction = SKAction.repeatForever(sequence)
        /// 执行Action
        playButton.run(repeatAction)
        
    }
    
    override func didEnter(from previousState: GKState?) {
        initPlayButton()
        scene.runBallRotate()
        scene.learnTemp.isHidden = false
    }
    override func willExit(to nextState: GKState) {
        playButton.isHidden = true
        scene.learnTemp.isHidden = true
    }
    // 正确无误 进入一下个State PlayState
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayState.Type
    }
    
    
}

