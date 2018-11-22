
// Created on: November 21
// Created by: Nick Pasco-Arnone
// Created for: ICS3U
// This programme can rotate between scences and move a sprite with buttons and shoot missiles with buttons 

// this will be commented out when code moved to Xcode
import PlaygroundSupport


import SpriteKit

class SplashScene: SKScene, SKPhysicsContactDelegate {
    // local variables to this scene
    let SplashSceneBackground = SKSpriteNode(imageNamed: "IMG_0951.JPG")
    let moveToNextSceneDelay = SKAction.wait(forDuration: 3.0)
    
    override func didMove(to view: SKView) {
        // this is run when the scene loads
        
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        
        SplashSceneBackground.name = "Splash scene background"
        SplashSceneBackground.position = CGPoint(x: frame.size.width/2, y: frame.size.height / 2)
        self.addChild(SplashSceneBackground) 
        
        SplashSceneBackground.run(moveToNextSceneDelay) {
            let mainMenuScene = MainMenuScene(size: self.size)
            self.view!.presentScene(mainMenuScene)
        }
        
        
    }
    
    override func  update(_ currentTime: TimeInterval) {
        //
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
}

class MainMenuScene: SKScene, SKPhysicsContactDelegate {
    // local variables to this scene
    
    override func didMove(to view: SKView) {
        // this is run when the scene loads
        let startButton = SKSpriteNode(imageNamed: "IMG_0882.PNG")
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        
        startButton.name = "start button"
        startButton.position = CGPoint(x: frame.size.width / 2, y: frame.size.height/2)
        self.addChild(startButton)
    }
    
    override func  update(_ currentTime: TimeInterval) {
        //
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var touch = touches as! Set<UITouch>
        var location = touch.first!.location(in: self)
        var touchedNode = self.atPoint(location)
        
        if let touchedNodeName = touchedNode.name {
            if touchedNodeName == "start button" {
                let mainGameScene = gameScene(size: self.size)
                self.view!.presentScene(mainGameScene)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
}

class gameScene: SKScene, SKPhysicsContactDelegate {
    // local variables to this scene
    let leftbutton = SKSpriteNode(imageNamed: "IMG_0936.PNG")
    let rightbutton = SKSpriteNode(imageNamed:  "IMG_0935.PNG")
    let spaceShip = SKSpriteNode(imageNamed:"IMG_0819.PNG")
    let fireButton = SKSpriteNode(imageNamed: "IMG_0821.PNG")
    var rightbuttonPressed = false
    var leftbuttonPressed = false
    var missles = [SKSpriteNode]()
    var aliens = [SKSpriteNode]()
    var alienAttackRate : Double = 1
    
    
    let collisionMissileCategory : UInt32 = 1
    let collisionAlienCategory : UInt32 = 2
    let collisionSpaceShipCategory : UInt32 = 4
    
    
    
    override func didMove(to view: SKView) {
        // this is run when the scene loads
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        
        spaceShip.name = "space ship"
        spaceShip.position = CGPoint(x: (frame.size.width / 2), y: 100)
        spaceShip.physicsBody?.isDynamic = true
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.affectedByGravity = false
        spaceShip.physicsBody?.usesPreciseCollisionDetection = true
        spaceShip.physicsBody?.categoryBitMask = collisionSpaceShipCategory
        spaceShip.physicsBody?.contactTestBitMask = collisionAlienCategory
        spaceShip.physicsBody?.collisionBitMask = 0x0
        self.addChild(spaceShip)
        spaceShip.setScale(0.65)
        
        rightbutton.name = "right button"
        rightbutton.position = CGPoint(x: 300 , y: 100)
        self.addChild(rightbutton)
        rightbutton.setScale(0.75)
        rightbutton.alpha = 0.5
        
        leftbutton.name = "left button"
        leftbutton.position = CGPoint(x: 100, y: 100)
        self.addChild(leftbutton)
        leftbutton.setScale(0.75)
        leftbutton.alpha = 0.5
        
        fireButton.name = "fire button"
        fireButton.position = CGPoint(x: frame.size.width - 100, y: 100)
        self.addChild(fireButton)
        fireButton.setScale(0.75)
        fireButton.alpha = 0.5
    }
    
    override func  update(_ currentTime: TimeInterval) {
        
        
        //
        if rightbuttonPressed == true && spaceShip.position.x <= screenSize.width - 150 {
            // nick add check for right boundary before moving
            var moveshipright = SKAction.moveBy(x: 10, y: 0, duration: 0.1)
            spaceShip.run(moveshipright)
        }
        else if leftbuttonPressed == true && spaceShip.position.x >= 50 {
            var moveshipleft = SKAction.moveBy(x: -10, y: 0, duration: 0.1)
            spaceShip.run(moveshipleft)
        }
        
        for aSingleMissile in missles {
            if aSingleMissile.position.y > frame.size.height {
                aSingleMissile.removeFromParent()
                missles.removeFirst()

            }
        }
        let createAlienChance = Int(arc4random_uniform(120) + 1)
        if createAlienChance <= Int(alienAttackRate) {
            createAlien()
        }
        for aSingleAlien in aliens {
        if aSingleAlien.position.y < spaceShip.position.y - 100 {
        aSingleAlien.removeFromParent()
        aliens.removeFirst()
        }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        let secondNode = contact.bodyB.node as! SKSpriteNode
        
        if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (collisionAlienCategory | collisionMissileCategory)) {
            
            spaceShip.run(SKAction.playSoundFileNamed("bomb-06.wav", waitForCompletion: false))
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            alienAttackRate += 0.05

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
        var touch = touches as! Set<UITouch>
        var location = touch.first!.location(in: self)
        var touchedNode = self.atPoint(location)
        
        if let touchedNodeName = touchedNode.name {
            if touchedNodeName == "right button" {
                rightbuttonPressed = true
            }
            else if touchedNodeName == "left button" {
            leftbuttonPressed = true
        }
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        var touch = touches as! Set<UITouch>
        var location = touch.first!.location(in: self)
        var touchedNode = self.atPoint(location)
        
        if let touchedNodeName = touchedNode.name {
            if touchedNodeName == "right button" {
                rightbuttonPressed = false
            }
            else if touchedNodeName == "left button" {
                leftbuttonPressed = false
            }
            else if touchedNodeName == "fire button" {
            
            let aMissile = SKSpriteNode(imageNamed: "IMG_0952.PNG")
            aMissile.position = CGPoint(x: spaceShip.position.x,y: 100)
            aMissile.name = "missile"
                aMissile.physicsBody?.isDynamic = true
                aMissile.physicsBody = SKPhysicsBody(texture: aMissile.texture!, size: aMissile.size)
                aMissile.physicsBody?.affectedByGravity = false
                aMissile.physicsBody?.usesPreciseCollisionDetection = true
                aMissile.physicsBody?.categoryBitMask = collisionMissileCategory
                aMissile.physicsBody?.contactTestBitMask = collisionSpaceShipCategory
                aMissile.physicsBody?.collisionBitMask = 0x0
            self.addChild(aMissile)
            let firemissile = SKAction.moveTo(y: frame.size.height + 100, duration: 2)
            aMissile.run(firemissile)
                missles.append(aMissile)
            aMissile.run(SKAction.playSoundFileNamed( "laser1.wav", waitForCompletion: false))
        }
        }
    }
    func createAlien() {
        let aSingleAlien = SKSpriteNode(imageNamed: "IMG_0820.PNG")
        aSingleAlien.name = "alien"
        
        aSingleAlien.physicsBody?.isDynamic = true
        aSingleAlien.physicsBody = SKPhysicsBody(texture: aSingleAlien .texture!, size: aSingleAlien .size)
        aSingleAlien.physicsBody?.affectedByGravity = false
        aSingleAlien .physicsBody?.usesPreciseCollisionDetection = true
        aSingleAlien.physicsBody?.categoryBitMask = collisionAlienCategory
        aSingleAlien .physicsBody?.contactTestBitMask = collisionMissileCategory
        aSingleAlien.physicsBody?.collisionBitMask = 0x0
        let alienStartPositionX = Int(arc4random_uniform(UInt32(frame.size.width - 0 + 1)))
        let alienEndPositionX = Int(arc4random_uniform(UInt32(frame.size.width - 0 + 1)))
        aSingleAlien.position = CGPoint(x: alienStartPositionX, y: Int(frame.size.height) + 100)
        let alienMove = SKAction.move(to: CGPoint(x:alienEndPositionX, y: -100), duration: 4)
        aSingleAlien.run(alienMove)
        self.addChild(aSingleAlien)
        aliens.append(aSingleAlien)
    }

    }


// this will be commented out when code moved to Xcode

// set the frame to be the size for your iPad
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

let scene = SplashScene(size: frame.size)
scene.scaleMode = SKSceneScaleMode.resizeFill

let skView = SKView(frame: frame)
skView.showsFPS = true
skView.showsNodeCount = true
skView.presentScene(scene)

PlaygroundPage.current.liveView = skView

