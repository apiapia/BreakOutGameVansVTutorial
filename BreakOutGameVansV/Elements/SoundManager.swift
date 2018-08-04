//
//  SoundManager.swift
//  BreakOutGameVansV
//
//  Created by Chen on 2018/7/15.
//  Copyright © 2018 iFiero. All rights reserved.
//

import Foundation
import SpriteKit

class SoundManager {
    
    let gameover = SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false)
    let gamewon  = SKAction.playSoundFileNamed("gamewon.mp3", waitForCompletion: false)
    let hitskateboard = SKAction.playSoundFileNamed("hitskateboard.caf", waitForCompletion: false)  /// 撞击skateboard
    let hitshoes  = SKAction.playSoundFileNamed("hitshoes.caf", waitForCompletion: false)   /// 鞋子
    // 建立单例 管理所有音乐文件
    static let shareInstanced = SoundManager()
}
