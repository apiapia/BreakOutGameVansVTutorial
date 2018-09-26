//
//  Device+Extension.swift
//  BreakOutGameVansV
//
//  Copyright © 2018 iFiero. All rights reserved.
//
/* iPhoneX      的分辨率：2436 * 1125 || pt: 812 * 375   ratio == 812/375 == 2.16
 * iPhoneXs     的分辨率：2436 * 1125 || pt: 812 * 375
 * iPhoneXs Max 的分辨率：2688 * 1242 || pt: 896 * 414   ratio == 896/414 == 2.16
 * iPhoneXr     的分辨率：1792 * 828  || pt: 896 * 414
 */

import UIKit
import SpriteKit

// iPhone X  375*812(H) @1x
// 竖屏
public let AREA_INSET_HEIGHT_TOP   :CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 44.0 : 0
public let AREA_INSET_HEIGHT_BOTTOM:CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 34.0 : 0
// 横屏(安全区域)
public let AREA_INSET_WIDTH_LEFT  :CGFloat = (UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.width == 896) ? 44.0 : 0
public let AREA_INSET_WIDTH_RIGHT :CGFloat = (UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.width == 896) ? 34.0 : 0

extension UIDevice {
    /// 是不是iPhoneX ,如果是竖屏则 UIScreen.main.bounds.height == 812
    public func isPhoneX() -> Bool {
        if UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.width == 896 {  /// 横屏
            return true
        }
        return false
    }
    /// 是不是iPad
    public func isPad() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad) ? true : false;
    }
    
}
