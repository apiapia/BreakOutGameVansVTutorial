//
//  ShoseNode.swift
//  BreakOutGameVansV
//
//  Created by Andrew 陈
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit

public class ShoseNode:SKSpriteNode  {
    /// 建立精灵节点 只能在Scene用代码调用!
    public static func newInstance(scene:SKScene) -> ShoseNode{
        //print(scene);
        let shoseNode = ShoseNode(imageNamed: "vansShose")
        let texture = SKTexture(imageNamed: "vansShose")
        shoseNode.physicsBody = SKPhysicsBody(texture:texture , size: texture.size())
        shoseNode.physicsBody?.affectedByGravity = false
        shoseNode.physicsBody?.isDynamic = false
        shoseNode.physicsBody?.categoryBitMask = PhysicsCategory.Shose
        shoseNode.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        shoseNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        // 这边是一个巨坑，千万不要把鞋子反弹力设为 1.0 否则会和球的反弹力相作用，反而让球的速度慢下来
        // self.physicsBody?.restitution = 1.0
        shoseNode.physicsBody?.friction = 0.0
        shoseNode.zPosition = 2
        return shoseNode
    }
}
