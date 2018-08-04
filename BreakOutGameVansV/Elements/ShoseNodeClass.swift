//
//  ShoseNode.swift
//  BreakOutGameVansV
//
//  Created by Andrew 陈
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit

public class ShoseNodeClass:SKSpriteNode  {
    /// 建立精灵节点 只能在Scene用代码调用!
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
}
