//
//  Device+Extension.swift
//  BreakOutGameVansV
//
//  Copyright © 2018 iFiero. All rights reserved.
//

import UIKit
import SpriteKit

// iPhone X  375*812(H) @1x
// 竖屏
public let AREA_INSET_HEIGHT_TOP   :CGFloat = (UIScreen.main.bounds.height == 812) ? 44.0 : 0
public let AREA_INSET_HEIGHT_BOTTOM:CGFloat = (UIScreen.main.bounds.height == 812) ? 34.0 : 0
// 横屏(安全区域)
public let AREA_INSET_WIDTH_TOP    :CGFloat = (UIScreen.main.bounds.width == 812) ? 44.0 : 0
public let AREA_INSET_WIDTH_BOTTOM :CGFloat = (UIScreen.main.bounds.width == 812) ? 34.0 : 0

public let iPhoneX_REAL_HEIGHT:CGFloat = 812.0   /// 竖屏

extension UIDevice {
    /// 是不是iPhoneX ,如果是竖屏则 UIScreen.main.bounds.height == 812
    public func isPhoneX() -> Bool {
        if UIScreen.main.bounds.width == 812 {  /// 横屏
            return true
        }
        return false
    }
    /// 是不是iPad
    public func isPad() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad) ? true : false;
    }
}
