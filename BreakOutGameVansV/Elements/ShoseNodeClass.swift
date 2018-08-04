//
//  ShoseNode.swift
//  BreakOutGameVansV
//
//  Created by Andrew 陈
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit

public class ShoseNodeClass:SKSpriteNode  {
    /// 建立精灵节点 可结合可视化Scene.sks 进行编辑 引入为Custom Class!
     func newInstance(scene:SKScene){
        //print(scene);
        //let shoseNode = ShoseNode(imageNamed: "vansShose")
        let texture = SKTexture(imageNamed: "vansShose")
        self.physicsBody = SKPhysicsBody(texture:texture , size: texture.size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Shose
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        // 这边是一个巨坑，千万不要把鞋子反弹力设为 1.0 否则会和球的反弹力相作用，反而让球的速度慢下来
        // self.physicsBody?.restitution = 0.0
        self.physicsBody?.friction = 0.0
        self.zPosition = 2
    }
    func runShake(scene:SKScene){
        //degreesToRadians 角度转化为弧度
       let upAction = SKAction.rotate(byAngle: CGFloat(-10).degreesToRadians(), duration: TimeInterval(0.1))
        upAction.timingMode = .easeInEaseOut
       let downAction = upAction.reversed()
        let sequence = SKAction.sequence([upAction,downAction])
        let repeatShake = SKAction.repeat(sequence, count: 2)
        self.run(repeatShake, withKey: "shake")
    }
}
