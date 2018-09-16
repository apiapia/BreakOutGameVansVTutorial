/*
 *  *** 游戏元素使用条款及注意事项 ***
 *
 *  游戏中的所有元素全部由iFIERO所原创(除注明引用之外)，包括人物、音乐、场景等;
 *  创作的初衷就是让更多的游戏爱好者可以在开发游戏中获得自豪感 -- 为游戏开发深感自豪;
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
 *  iFIERO -- 为游戏开发深感自豪
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

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //MARK: - StateMachine 场景中各个舞台State
    lazy var stateMachine:GKStateMachine = GKStateMachine(states: [
        WaitingState(scene: self),
        PlayState(scene: self),
        GameOverState(scene: self)])
    
    private var fgNode = SKNode()
    private var ballNode = BallNode()
    private var shoseOverlay:SKSpriteNode! /// 鞋子精灵Parent 位于 shoseOverlay 节点下
    private var gameSceneOverlay:SKSpriteNode! //复制的鞋子精灵
    private var shoseNode:ShoseNodeClass!   /// 鞋子精灵
    private var skateboard = Skateboard()
    private var maxAspectRatio:CGFloat! /// 屏幕分辩率;
    private var ballMaxSpeed:CGFloat = 1500.00 // 最大速度；
    private var ballInitSpeed:CGFloat = 1000.00 // 初始速度；
    private var playableRect:CGRect!   /// 可视范围
    private var playableHeight:CGFloat  = 0.0   /// 可视范围的高度
    private var playableMargin:CGFloat = 0.0   /// 可视范围的起点
    var learnTemp:SKSpriteNode!
    var playButtonTemp:SKSpriteNode!
    
    private var dt:TimeInterval = 0  /// 每一frame的时间差
    private var lastUpdateTimeInterval:TimeInterval = 0
    private var avPlayer:AVAudioPlayer!
    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)  /// 物理世界的重力
        self.physicsWorld.contactDelegate = self               /// 碰撞代理
        
        learnTemp   = childNode(withName: "learnTemp") as! SKSpriteNode
        playButtonTemp   = childNode(withName: "playButton") as! SKSpriteNode
        initCheckDevice()
        setupBall()       /// 球
        setupSkateboard() /// 滑板
        setupShose()      /// 鞋子
        setupBgMusic()    // 加入背景音乐;
        
        stateMachine.enter(WaitingState.self) // 进入WaitingState
        
    }
    // option+command+->展开
    // MARK: - 检测是哪种设备
    func initCheckDevice(){
        if UIDevice.current.isPhoneX() {
            maxAspectRatio = 2.16         /// iPhoneX 2.16 ratio
        }else {
            maxAspectRatio  = UIDevice.current.isPad() ? (4.0 / 3.0) : (16.0 / 9.0)  /// iPhone 16:9,iPad 4:3
        }
        /// 画出可视区域
        drawPayableArea(size: self.size,ratio: maxAspectRatio)
    }
    // MARK: - command + option + 左or右箭头 可以折叠/拓展函数
    // MARK: - 画出可视区域
    func drawPayableArea(size:CGSize,ratio:CGFloat){
        /*
         /// 安全区域即用户交互的区域，非可视区域 (iPhoneX的安全区域 < 可视区域)
         let safeInsetTop    =  self.size.height * AREA_INSET_WIDTH_TOP / iPhoneX_REAL_HEIGHT
         let safeInsetBottom =  self.size.height * AREA_INSET_WIDTH_BOTTOM / iPhoneX_REAL_HEIGHT
         let safeHeight = self.size.height - safeInsetTop - safeInsetBottom   // 安全区域的高度
         */
        
        playableHeight  = size.width / ratio
        playableMargin = (size.height - playableHeight ) / 2.0   /// P70
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height:  playableHeight)  /// 注意 scene的anchorPoint(0,0)原点的位置;
        
        let shapeFrame = SKShapeNode(rect: playableRect)
        shapeFrame.zPosition = 1
        shapeFrame.strokeColor = SKColor.red
        shapeFrame.lineWidth = 5.0
        addChild(shapeFrame)
        
        /// 可视区域的物理状态
        let playableBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        playableBody.friction = 0
        self.physicsBody = playableBody
        playableBody.categoryBitMask    = PhysicsCategory.Frame
        playableBody.contactTestBitMask = PhysicsCategory.Ball
        playableBody.collisionBitMask   = PhysicsCategory.Ball
        
        /// 地板
        setupFloor()
    }
    //MARK: - 地板
    func setupFloor(){
        let floor = SKNode()
        let startPoint = CGPoint(x: 0.0, y: playableMargin)
        let endPoint   = CGPoint(x: self.size.width, y: playableMargin)
        self.addChild(floor)
        floor.physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        floor.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Ball /// 和球相碰
    }
    //MARK: - 球
    func setupBall(){    
        ballNode = childNode(withName: "ball") as! BallNode
        ballNode.setup(scene:self.scene!)  // 导入size与physicsBody
    }
    
    func runBallRotate(){
        ballNode.rotate()
    }
    func runBall(){
        ballNode.physicsBody?.applyImpulse(CGVector(dx: 100.0, dy: -ballInitSpeed)) /// dy的绝对值越大 球速越快; - 表示向下
    }
    func runBallInvincible(){
        // 即碰到底部不会lose掉game
        print("Invincible")
        ballNode.physicsBody?.categoryBitMask = PhysicsCategory.None
    }
    //MARK: - 滑板
    func setupSkateboard(){
        skateboard = childNode(withName: "skateboard") as! Skateboard
        skateboard.setup(scene: self.scene!)
    }
    //MARK: - 鞋子
    func setupShose(){
        // 一、直接在场景中加入节点，不利于重复利用,以后每一关卡都要重建，非常麻烦;
        // 1.代码创建精灵节点到GameScene
        //         let xPos = self.frame.width / 2
        //         let yPos = playableHeight - 100
        //         shoseNode = ShoseNode.newInstance(scene: self)
        //         shoseNode.position = CGPoint(x: xPos, y: yPos)
        //         self.addChild(shoseNode)
        // 2.用Class可视化加入精灵节点
        /*
         shoseNode = childNode(withName: "shose") as! ShoseNodeClass
         shoseNode.newInstance(scene: self.scene!)
         
         let emitter = SKEmitterNode(fileNamed: "Fire")!
         emitter.zPosition = 1
         emitter.targetNode = shoseNode
         emitter.setScale(3.0)
         shoseNode.addChild(emitter)
         */
        // 二、引用其它scene的节点到当前Scene中，需要convert转化到当前GameScene的坐标
        var sceneName = ""
        sceneName = (CGFloat.random(1, max: 100) > 50) ? "ShoseCrossScene" : "ShoseScene"
        let overlayScene = SKScene(fileNamed: sceneName)!
        let overlayShose = overlayScene.childNode(withName: "Overlay") as! SKSpriteNode
        gameSceneOverlay = overlayShose.copy() as! SKSpriteNode
        overlayShose.removeFromParent() // 移除旧的
        /* 留意SpirteKit的巨坑
         * When an overlay node with actions is copied  there is currently a SpriteKit bug
         * where the node’s isPaused property might be set to true
         * 一定要记得设置为 false 或者所有gamesceneOverlay内的子节点的所有action都不起作用
         */
        gameSceneOverlay.isPaused = false;
        gameSceneOverlay.enumerateChildNodes(withName: "shose") { (node, _) in
            let sprite = node as! ShoseNodeClass
            sprite.newInstance(scene: self.scene!) // 加入物理体;
        }
        gameSceneOverlay.zPosition = 2
        let yPos = self.frame.size.height - playableMargin - 150;
        gameSceneOverlay.position = CGPoint(x: 1024, y: yPos)
        self.addChild(gameSceneOverlay)
        
    }
    //MARK:背景音乐
    func setupBgMusic(){
        // let music = SKAudioNode(fileNamed: "bgmusic.mp3")
        // music.autoplayLooped = true
        // self.addChild(music)
        // 背景音乐
        let path = Bundle.main.path(forResource: "bgmusic", ofType: "mp3")
        let pathUrl = URL(fileURLWithPath: path!)
        do {
            try avPlayer = AVAudioPlayer(contentsOf: pathUrl)
        }catch {
            // return 在catch不使用return的原因是 即使因声音播放不了 还是让整个游戏运行
            print("mp3 error")
        }
        avPlayer.play()
        avPlayer.volume = 0.2
    }
    // 返回 -80.0 或 80.0 角度50 已经很小了;
    func randomDirection() -> CGFloat {
        var xSpeed:CGFloat = 80.0
        if CGFloat.random(1, max: 100) > 50 {
            xSpeed = -xSpeed
        }
        return xSpeed
    }
    //MARK: - 时时校验球的运动速度和方向
    func verifyBallSpeed(_ dt:TimeInterval){
        
        let xSpeed:CGFloat = abs((ballNode.physicsBody?.velocity.dx)!) /// 水平方向的dx
        let ySpeed:CGFloat = abs((ballNode.physicsBody?.velocity.dy)!)
        /// print("xSpeed:" , xSpeed)
        /// 为什么xSpeed是100，不是凭空乱猜的,可以根据打印出来的xSpeed进行查看(即快接近垂直时的角度差不多为50);
        if xSpeed < 100 { // xSpeed很小，表示球正在上下来回运动 必须赋一个值 让球再次向左右水平方向运动;
            ballNode.physicsBody?.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        }
        if ySpeed < 100 {
            ballNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
        }
        /// 三角函数 C(斜边)= sqrt(a*a + b*b) 得出球的运动速度
        let ballSpeed = sqrt((ballNode.physicsBody?.velocity.dx)! * (ballNode.physicsBody?.velocity.dx)! + (ballNode.physicsBody?.velocity.dy)! * (ballNode.physicsBody?.velocity.dy)!)
        /// 防止球的运动速度过快 把球的速度打印出来 就可以知道大概 maxSpeed要设置多少了;
        ballNode.physicsBody?.linearDamping = (ballSpeed > ballMaxSpeed) ? 0.2 : 0.0
        //print("ballSpeed",ballSpeed);
    }
    // 特效果汁
    func emitParticles(particleName: String, sprite: SKSpriteNode) {
     
        let scenePos = convert(sprite.position, from: sprite.parent!)
        let emitter = SKEmitterNode(fileNamed: "Fire")!
        emitter.zPosition = 5  // 位于鞋子的上方;
        emitter.position = scenePos
        emitter.setScale(3.0)
        self.addChild(emitter)
        
        let node = sprite as! ShoseNodeClass
        node.runShake(scene: self.scene!)
        
        sprite.run(SKAction.sequence([
            SKAction.wait(forDuration: TimeInterval(0.5)),
            //SKAction.scale(to: 0.0, duration: TimeInterval(0.08)),
            SKAction.fadeAlpha(to: 0.0, duration: TimeInterval(0.3)),
            SKAction.run {
                emitter.removeFromParent()
            },
            SKAction.run {
                sprite.removeFromParent()
            },
            SKAction.run {
                // print ("设置copy()后的精灵节点的isPaused=false后，此行才会执行")
            }
            ]))
    }
    
    func restartGame(){
        let newScene = GameScene(fileNamed: "GameScene")!
        newScene.size = CGSize(width: SCENE_WIDTH, height: SCENE_HEIGHT)
        newScene.anchorPoint = CGPoint(x: 0, y: 0)
        newScene.scaleMode   = .aspectFill
        let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
        view?.presentScene(newScene, transition:transition)
    }
    //MARK: - 实现物理碰撞代理SKPhysicsContactDelegate的didBegin方法
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA:SKPhysicsBody
        let bodyB:SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        }else{
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        /// 球和四周发生碰撞
        if (bodyA.categoryBitMask == PhysicsCategory.Ball && bodyB.categoryBitMask == PhysicsCategory.Frame) {
        }
        
        /// 球和鞋子发生碰撞
        if (bodyA.categoryBitMask == PhysicsCategory.Ball && bodyB.categoryBitMask == PhysicsCategory.Shose) {
            // print(PhysicsCategory.Ball ,PhysicsCategory.Shose)
            emitParticles(particleName: "Fire", sprite: bodyB.node as! SKSpriteNode)
            bodyB.node?.physicsBody?.categoryBitMask = PhysicsCategory.None
        }
        
        /// 球和滑板发生碰撞
        if (bodyA.categoryBitMask == PhysicsCategory.Ball && bodyB.categoryBitMask == PhysicsCategory.Skateboard) {
            //print("Skateboard")
            self.run(SoundManager.shareInstanced.hitskateboard)
        }
        
        /// 球和地板发生碰撞
        if (bodyA.categoryBitMask == PhysicsCategory.Ball && bodyB.categoryBitMask == PhysicsCategory.Floor) {
            //print("Game Over")
            self.run(SoundManager.shareInstanced.gameover)
            bodyB.node?.physicsBody?.categoryBitMask = PhysicsCategory.None
            bodyA.node?.physicsBody?.linearDamping = 1.0 /// 阻力为1.0
            bodyA.node?.physicsBody?.restitution = 0.7  /// 反弹;
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
            stateMachine.enter(GameOverState.self)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        // 当 physicsWorld.body(at: touchLocation)为nil时
        // 采用atPoint 取得场景中的的精灵
        let touchLocation = touch.location(in: self) ///获得点击的位置
        let nodeAtPoint = self.atPoint(touchLocation) //返回SKNode
        /// 判断目前的GameScene场景舞台是哪个state
        switch stateMachine.currentState {
        case is WaitingState:
            
            /// 判断是否是点击了PlayButton
            if nodeAtPoint.name == "playButton" {
                stateMachine.enter(PlayState.self)
            }
            
            if nodeAtPoint.name == "learnTemp" {
                 print("weird")
                UIApplication.shared.open(URL(string: "http://www.iFIERO.com")!, options: [:], completionHandler: { (error) in
                    print("jump to http://www.iFiero.com")
                })
            }
            
        case is PlayState:
            print("playing")
        case is GameOverState:
           
            if nodeAtPoint.name == "tapToPlay" {
                restartGame()
            }
            
        default:
            break;
        }
    }
    
    func gameOver(){
        // 进入游戏结束的state
        stateMachine.enter(GameOverState.self)
        ballNode.physicsBody?.affectedByGravity = true 
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
    
    func isGameWon() -> Bool {
        // 初始值 为 0 ，表示没有shose了;
        var numberOfShoses = 0
        // 这个是判断是不是还有shose，有则为 1
        gameSceneOverlay.enumerateChildNodes(withName: "shose") {  node, _ in
            numberOfShoses = 1
        }
        return numberOfShoses == 0  // 真或者假 numberOfShoses >0 返回假
    }
    //MARK: - 时时更新
    override func update(_ currentTime: TimeInterval) {
        /// 获取时间差
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        stateMachine.update(deltaTime: dt)  // 调用所有State内的update方法
        
    }
}




