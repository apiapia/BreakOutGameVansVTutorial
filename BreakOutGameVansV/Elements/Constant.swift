//
//  Constant.swift
//  BreakOutGameVansV
//
//  Created by Andrew Chen
//  Copyright © 2018 iFiero. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    
    static let Ball:UInt32  = 0x1 << 1
    static let Skateboard:UInt32 = 0x1 << 2
    static let Shose:UInt32 = 0x1 << 3
    static let Floor:UInt32 = 0x1 << 4 /// 地板
    static let Frame:UInt32 = 0x1 << 5 /// 4周边框
    static let None:UInt32  = 0x1 << 6
}
