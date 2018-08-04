/* 注：此文件中的代码为iFIERO所引用  Copyright by Razeware LLC */

import CoreGraphics
import SpriteKit
/**   π as a CGFloat 180度 */
let π = CGFloat(Double.pi)

public extension CGFloat {
    /**
     * 角度转化为弧度.
     */
    public func degreesToRadians() -> CGFloat {
        return π * self / 180.0
    }
    
    /**
     * 弧度转化为角度.
     */
    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / π
    }

    /**
     *  0.0 and 1.0 随机数.
     */
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    /**
     *   min...max 的随机数.
     */
    public static func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
}
