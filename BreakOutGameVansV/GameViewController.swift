/*
 *  *** 游戏元素使用条款及注意事项 ***
 *
 *  游戏中的所有元素全部由iFIERO所原创(除注明引用之外)，包括人物、音乐、场景等;
 *  创作的初衷就是让更多的游戏爱好者可以在开发游戏中获得自豪感 -- 让手机游戏开发变得简单;
 *  秉着开源分享的原则,iFIERO发布的游戏都尽可能的易懂实用，并开放所有源码;
 *  任何使用者都可以使用游戏中的代码块，也可以进行拷贝、修改、更新、升级，无须再经过iFIERO的同意;
 *  但这并不表示可以任意复制、拆分其中的游戏元素:
 *  用于[商业目的]而不注明出处;
 *  用于[任何教学]而不注明出处;
 *  用于[游戏上架]而不注明出处；
 *  另外,iFIERO有商用授权游戏元素，获得iFIERO官方授权后，即无任何限制;
 *  请尊重帮助过你的iFIERO的知识产权，非常感谢;
 *
 *  Created by VANGO杨 && ANDREW陈
 *  Copyright © 2018 iFiero. All rights reserved.
 *  www.iFIERO.com
 *  iFIERO -- 让手机游戏开发变得简单
 *
 *  BreakOutGame 弹潮V 在此游戏中您将获得如下主要技能:
 *
 *  1.GameScene Size   学习精确适配各种iPhone尺寸;
 *  2.GameplayKit      学习如何应用GameplayKit切换游戏状态;
 *  3.Velocity         三角函数求向量、判断球的速度;
 *  4.TouchBegan       学习触碰移动事件直接写在精灵中
 *  5.SoundManager     学习设置单例管理所有音乐;
 *  6.PhysicsBody      学习最基本物理碰撞特性 反弹 摩擦力;
 *  7.SKNode+SKScene   建立空节点+引入自定义Scene+node.copy+isPaused=false (**重要技能**)
 *  8.Convert          学习转换其它场景Scene的坐标到当前GameScene坐标;
 *
 */

import UIKit
import SpriteKit
import GameplayKit

public let SCENE_WIDTH:CGFloat  = 2048
public let SCENE_HEIGHT:CGFloat = 1536

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
        
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.size = CGSize(width: SCENE_WIDTH, height: SCENE_HEIGHT)
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
          //view.showsPhysics = true 
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
