//
//  Skateboard.swift
//  BreakOutGameVansV
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit

public class Skateboard:SKSpriteNode {
    
    var isFingerOnBoard = false /// 是否在滑板
    
    //MARK:-  设置节点
    func setup(scene: SKScene) {
        
        // print("is user interaction enabled")
        isUserInteractionEnabled = true  /// 是否允许交互
        
        let boardSize = SKTexture(imageNamed: "vansSkateboard").size()
        // 0.9的意思是 GameScene.sks 可视化拖进精灵时 有缩小scale 0.9 所以SKTexture的物理身体也要相应缩小 0.9 
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "vansSkateboard"),
                                         size: CGSize(width: boardSize.width * 0.9, height: boardSize.height * 0.9))
        physicsBody?.affectedByGravity = false  /// 不受重力影响
        physicsBody?.isDynamic = false          /// 碰撞后不发生位移
        physicsBody?.allowsRotation = false    ///  不旋转
        physicsBody?.friction = 0.0    /// 不要有摩擦力;
        physicsBody?.categoryBitMask = PhysicsCategory.Skateboard
        physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        physicsBody?.collisionBitMask = PhysicsCategory.Ball
    }
    
    //MARK: - 触摸行为写在SKSpriteNode 内部  减轻GameScene的代码量
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnBoard = true
        print("touch skate board")
    }
    //MARK: -  移动
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if isFingerOnBoard {
            guard let touch = touches.first else { return }
            let touchLoc = touch.location(in: self)
            let touchPreviousLoc = touch.previousLocation(in: self)  /// 上一次点击
            var  boardXPos = self.position.x + (touchLoc.x  - touchPreviousLoc.x) // 获得最新的位置
            /// 判断位置;
            if boardXPos < self.size.width / 2 {
                boardXPos = self.size.width / 2
            }
            if boardXPos > ((scene?.size.width)! - self.size.width / 2) {
                boardXPos = (scene?.size.width)! - self.size.width / 2
            }
            self.position.x = boardXPos  /// 更新位置
        }
       
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnBoard = false
    }
    
}
