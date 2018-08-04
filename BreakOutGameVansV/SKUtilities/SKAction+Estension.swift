/* 注：此文件中的代码为iFIERO所引用  Copyright by Razeware LLC */

//  SKAction+Estension.swift
//  BreakOutGameVansV
//
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit

public extension SKAction {
    /**
     * Performs an action after the specified delay.
     */
    public class func afterDelay(_ delay: TimeInterval, performAction action: SKAction) -> SKAction {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }
    
    /**
     * Performs a block after the specified delay.
     */
    public class func afterDelay(_ delay: TimeInterval, runBlock block: @escaping () -> Void) -> SKAction {
        return SKAction.afterDelay(delay, performAction: SKAction.run(block))
    }
    
    /**
     * Removes the node from its parent after the specified delay.
     */
    public class func removeFromParentAfterDelay(_ delay: TimeInterval) -> SKAction {
        return SKAction.afterDelay(delay, performAction: SKAction.removeFromParent())
    }
    
}
