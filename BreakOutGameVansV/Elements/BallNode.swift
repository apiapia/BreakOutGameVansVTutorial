//
//  PlayerNode.swift
//  BreakOutGameVansV
//
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit

public class BallNode:SKSpriteNode  {
    /// 建立精灵节点
    func setup(scene:SKScene){
        self.zPosition = 3  
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody?.affectedByGravity  = true // 掉在地板后才不会再弹起;
        physicsBody?.isDynamic =  true
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0   /// 反弹力 详见 http://www.ifiero.com/index.php/archives/492
        physicsBody?.categoryBitMask    = PhysicsCategory.Ball
        /// 球和谁发生碰撞后发出通知
        physicsBody?.contactTestBitMask = PhysicsCategory.Frame | PhysicsCategory.Skateboard | PhysicsCategory.Floor | PhysicsCategory.Shose
        physicsBody?.collisionBitMask   = PhysicsCategory.Frame | PhysicsCategory.Skateboard | PhysicsCategory.Shose
        // physicsBody?.usesPreciseCollisionDetection = true 
        /// 粒子
        let trailNode = SKNode()
        trailNode.zPosition = 1
        scene.addChild(trailNode)
        /// 粒子效果
        let emitterNode = SKEmitterNode(fileNamed: "Trail")!
        emitterNode.targetNode = trailNode
        self.addChild(emitterNode)
        
    }
    /// 旋转
    func rotate(){
        let rotate = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration: TimeInterval(0.2))
        let repeatAction = SKAction.repeatForever(rotate)
        self.run(repeatAction, withKey: "rotated")
    }
    
    func stopRotated(){
        self.removeAction(forKey: "rotated")
    }
}
