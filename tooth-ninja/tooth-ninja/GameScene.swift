////
////  GameScene.swift
////  tooth-ninja
////
////  Created by David Lopez on 7/4/18.
////  Copyright © 2018 David Lopez. All rights reserved.
////
//
//import SpriteKit
//import GameplayKit
//
//struct PhysicsCategory {
//    static let None         : UInt32 = 0
//    static let External     : UInt32 = 0x1 << 1
//    static let Player       : UInt32 = 0x1 << 2
//}
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    var scoreLabel: SKLabelNode!
//    var healthLabel: SKLabelNode!
//
//    var score = 0 {
//        didSet {
//            scoreLabel.text = "Score: \(score)"
//        }
//    }
//
//    var health = 100 {
//        didSet {
//            if health > 100 {
//                health = 100
//            }
//            healthLabel.text = "HP: \(health)%"
//        }
//    }
//
//    var shield = 0
//
//    // This optional variable will help you to easily access the blade
//    var blade: SwipeNode?
//
//    // This will help you to update the position of the blade
//    // Set the initial value to 0
//    var delta: CGPoint = .zero
//
//    override func didMove(to view: SKView) {
//
//        let background = SKSpriteNode(imageNamed: "background2")
//        background.zPosition = 1
//        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
//        print("background, scene size is \(self.size.width) and \(self.size.height)")
//        background.size = size
//        addChild(background)
//
//        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
//        scoreLabel.text = "Score: 0"
////        scoreLabel.horizontalAlignmentMode = .right
//        scoreLabel.zPosition = 2
//        scoreLabel.fontSize = 25
//        scoreLabel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
//        addChild(scoreLabel)
//
//        healthLabel = SKLabelNode(fontNamed: "Chalkduster")
//        healthLabel.text = "HP: 100%"
//        healthLabel.fontSize = 25
//        healthLabel.zPosition = 2
//        healthLabel.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
//        addChild(healthLabel)
//
//
//        Tooth.addTooth(position: CGPoint(x: size.width * 0.572, y: size.height * 0.32), scene: self)
//        Tooth.addTooth(position: CGPoint(x: size.width * 0.422, y: size.height * 0.32), scene: self)
//
//        physicsWorld.gravity = CGVector.zero
//        physicsWorld.contactDelegate = self
//
//        let s1 = SKAction.run {
//            addBacteria(scene: self, completion: {
//                print("add bacteria")
//            })
//        }
//
//        let s2 = SKAction.run {
//            addBacteria2(scene: self, completion: {
//                print("add bacteria")
//            })
//        }
//        run(SKAction.repeatForever(SKAction.sequence([
//            SKAction.run(addGoodBacteria),
//            s1,
//            s1,
//            s1,
//            s1,
//            SKAction.wait(forDuration: 1.0),
//            SKAction.run(addGoodFood),
//            SKAction.wait(forDuration: 1.0),
//            SKAction.run(addBadFood),
//            SKAction.wait(forDuration: 1.0),
//            s1,
//            SKAction.wait(forDuration: 1.0),
//            s2,
//            SKAction.wait(forDuration: 1.0)
//            ])
//        ))
//    }
//
////
//    func addGoodFood() {
//
//        // Create sprite
//        let goodFood = SKSpriteNode(imageNamed: "cheese")
//        goodFood.name = "goodfood"
//
//        goodFood.size.width = CGFloat(50)
//        goodFood.size.height = CGFloat(50)
//
//        let actualY = SpriteCreation.random(min: size.height*0.1, max: size.height*0.9)
//        let actualX = SpriteCreation.random(min: size.width*0.1, max: size.width*0.9)
//
//        // Position the food slightly off-screen along the right edge,
//        // and along a random position along the Y axis as calculated above
//        goodFood.position = CGPoint(x: actualX, y: actualY)
//        goodFood.zPosition = 2
//
//        goodFood.physicsBody = SKPhysicsBody(circleOfRadius: max(goodFood.size.width/2, goodFood.size.height/2))
//        goodFood.physicsBody?.isDynamic = true
//        goodFood.physicsBody?.categoryBitMask = PhysicsCategory.External
//        goodFood.physicsBody?.contactTestBitMask = PhysicsCategory.Player
//        goodFood.physicsBody?.collisionBitMask = PhysicsCategory.None
//
//        // Add the food to the scene
//        addChild(goodFood)
//
//        // Determine speed of the food
//        let actualDuration = SpriteCreation.random(min: CGFloat(2.0), max: CGFloat(4.0))
//
//        // Create the actions
//        let teeth = self["tooth"]
//        print("There are \(teeth.count) teeth")
//
//        let targetToothIndex = SpriteCreation.random(min: 0, max: CGFloat(teeth.count))
//        let targetTooth = teeth[Int(targetToothIndex)]
//
//        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))
//
//        goodFood.run(actionMove)
//    }
//
////
//    func addBadFood() {
//
//        // Create sprite
//        let goodFood = SKSpriteNode(imageNamed: "chocolate")
//        goodFood.name = "badfood"
//
//        goodFood.size.width = CGFloat(30)
//        goodFood.size.height = CGFloat(50)
//
//        let actualY = SpriteCreation.random(min: size.height*0.1, max: size.height*0.9)
//        let actualX = SpriteCreation.random(min: size.width*0.1, max: size.width*0.9)
//
//        // Position the food slightly off-screen along the right edge,
//        // and along a random position along the Y axis as calculated above
//        goodFood.position = CGPoint(x: actualX, y: actualY)
//        goodFood.zPosition = 2
//
//        goodFood.physicsBody = SKPhysicsBody(rectangleOf: goodFood.size)
//        goodFood.physicsBody?.isDynamic = true
//        goodFood.physicsBody?.categoryBitMask = PhysicsCategory.External
//        goodFood.physicsBody?.contactTestBitMask = PhysicsCategory.Player
//        goodFood.physicsBody?.collisionBitMask = PhysicsCategory.None
//
//        // Add the food to the scene
//        addChild(goodFood)
//
//        // Determine speed of the food
//        let actualDuration = SpriteCreation.random(min: CGFloat(2.0), max: CGFloat(4.0))
//
//        // Create the actions
//        let teeth = self["tooth"]
//        print("There are \(teeth.count) teeth")
//
//        let targetToothIndex = SpriteCreation.random(min: 0, max: CGFloat(teeth.count))
//        let targetTooth = teeth[Int(targetToothIndex)]
//
//        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))
//
//        goodFood.run(actionMove)
//    }
//
//    func addGoodBacteria() {
//
//        // Create sprite
//        let goodFood = SKSpriteNode(imageNamed: "good_bac")
//        goodFood.name = "goodbacteria"
//
//        goodFood.size.width = CGFloat(50)
//        goodFood.size.height = CGFloat(60)
//
//        let actualY = SpriteCreation.random(min: size.height*0.1, max: size.height*0.9)
//        let actualX = SpriteCreation.random(min: size.width*0.1, max: size.width*0.9)
//
//        // Position the food slightly off-screen along the right edge,
//        // and along a random position along the Y axis as calculated above
//        goodFood.position = CGPoint(x: actualX, y: actualY)
//        goodFood.zPosition = 2
//
//        goodFood.physicsBody = SKPhysicsBody(rectangleOf: goodFood.size)
//        goodFood.physicsBody?.isDynamic = true
//        goodFood.physicsBody?.categoryBitMask = PhysicsCategory.External
//        goodFood.physicsBody?.contactTestBitMask = PhysicsCategory.Player
//        goodFood.physicsBody?.collisionBitMask = PhysicsCategory.None
//
//        // Add the food to the scene
//        addChild(goodFood)
//
//        // Determine speed of the food
//        let actualDuration = SpriteCreation.random(min: CGFloat(2.0), max: CGFloat(4.0))
//
//        // Create the actions
//        let teeth = self["tooth"]
//        print("There are \(teeth.count) teeth")
//
//        let targetToothIndex = SpriteCreation.random(min: 0, max: CGFloat(teeth.count))
//        let targetTooth = teeth[Int(targetToothIndex)]
//
//        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))
//
//        goodFood.run(actionMove)
//    }
//
//    func bacteriaCollidesWithTooth(bacteria: SKSpriteNode) {
//        print("Collision: Bacteria-Tooth")
//        bacteria.removeFromParent()
//        if (shield <= 0) {
//            health -= 5
//        } else {
//            shield -= 1
//        }
//        if (health <= 0) {
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: false)
//            self.view?.presentScene(gameOverScene, transition: reveal)
//        }
//    }
//
//    func bacteria2CollidesWithTooth(bacteria: SKSpriteNode) {
//        print("Collision: Bacteria-Tooth")
//        if (shield <= 0) {
//            health -= 5
//        } else {
//            shield -= 1
//        }
//        if (health <= 0) {
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: false)
//            self.view?.presentScene(gameOverScene, transition: reveal)
//        }
//    }
//
//    func goodBacteriaCollidesWithTooth(bacteria: SKSpriteNode) {
//        print("Collision: GoodBacteria-Tooth")
//        bacteria.removeFromParent()
//        shield = 10
//    }
//
//
//    func swipeCollidesWithBacteria(bacteria: SKSpriteNode) {
//        print("Collision: Swipe-Bacteria")
//        bacteria.removeFromParent()
//        score += 1
//    }
//
//    func goodFoodCollidesWithTooth(goodFood: SKSpriteNode) {
//        print("Collision: GoodFood-Tooth")
//        goodFood.removeFromParent()
//        health += 10
//    }
//
//    func badFoodCollidesWithTooth(badFood: SKSpriteNode) {
//        print("Collision: BadFood-Tooth")
//        badFood.removeFromParent()
//        let s1 = SKAction.run {
//            addBacteria(scene: self, completion: {
//                print("add bacteria")
//            })
//        }
//        let influx = SKAction.repeat(s1, count: 5)
//        let action = SKAction.sequence([
//            influx,
//            SKAction.wait(forDuration: 1),
//            influx,
//            SKAction.wait(forDuration: 1),
//            influx,
//            SKAction.wait(forDuration: 1)
//            ])
//        run(action)
//    }
//
//    func swipeCollidesWithGoodFood(goodFood: SKSpriteNode) {
//        print("Collision: Swipe-GoodFood")
//        goodFood.removeFromParent()
//    }
//
//    func swipeCollidesWithBadFood(badFood: SKSpriteNode) {
//        print("Collision: Swipe-BadFood")
//        badFood.removeFromParent()
//    }
//
//    func swipeCollidesWithGoodBacteria(bacteria: SKSpriteNode) {
//        print("Collision: Swipe-GoodBacteria")
//        bacteria.removeFromParent()
//    }
//
//    func didBegin(_ contact: SKPhysicsContact) {
//        var playerBody: SKPhysicsBody
//        var externalBody: SKPhysicsBody
//
//        print("body a bitmask: \(contact.bodyA.categoryBitMask)")
//        print("body b bitmask: \(contact.bodyB.categoryBitMask)")
//        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
//            playerBody = contact.bodyA
//            externalBody = contact.bodyB
//        } else {
//            playerBody = contact.bodyB
//            externalBody = contact.bodyA
//        }
//        print("player body is set to: \(playerBody.categoryBitMask)")
//        print("external body is set to: \(externalBody.categoryBitMask)")
//
//        if playerBody.node?.name == "swipe" {
//            if externalBody.node?.name == "bacteria" || externalBody.node?.name == "bacteria2" || externalBody.node?.name == "goodbacteria"  {
//                if let bacteria = externalBody.node as? SKSpriteNode {
//                    swipeCollidesWithBacteria(bacteria: bacteria)
//                }
//            }else if externalBody.node?.name == "goodfood" {
//                if let goodFood = externalBody.node as? SKSpriteNode {
//                    swipeCollidesWithGoodFood(goodFood: goodFood)
//                }
//            }else if externalBody.node?.name == "badfood" {
//                if let badFood = externalBody.node as? SKSpriteNode {
//                    swipeCollidesWithBadFood(badFood: badFood)
//                }
//            }
//        }else {
//            if externalBody.node?.name == "bacteria" || externalBody.node?.name == "bacteria2" {
//                if let bacteria = externalBody.node as? SKSpriteNode {
//                    bacteria2CollidesWithTooth(bacteria: bacteria)
//                }
//            }else if externalBody.node?.name == "goodbacteria" {
//                if let goodbacteria = externalBody.node as? SKSpriteNode {
//                   goodBacteriaCollidesWithTooth(bacteria: goodbacteria)
//                }
//            }else if externalBody.node?.name == "goodfood" {
//                if let goodFood = externalBody.node as? SKSpriteNode {
//                    goodFoodCollidesWithTooth(goodFood: goodFood)
//                }
//            }else if externalBody.node?.name == "badfood" {
//                if let badFood = externalBody.node as? SKSpriteNode {
//                    badFoodCollidesWithTooth(badFood: badFood)
//                }
//            }
//        }
//    }
//
//    // This will help you to initialize our blade
//    func presentBladeAtPosition(_ position:CGPoint) {
//        blade = SwipeNode(position: position, target: self, color: .white)
//
//        guard let blade = blade else {
//            fatalError("Blade could not be created")
//        }
//        blade.enablePhysics(categoryBitMask: PhysicsCategory.Player, contactTestBitmask: PhysicsCategory.External, collisionBitmask: PhysicsCategory.None)
//
//        addChild(blade)
//    }
//
//    // This will help you to remove the blade and reset the delta value
//    func removeBlade() {
//        guard let blade = blade else {
//            return
//        }
//
//        blade.removeFromParent()
//        delta = .zero
//    }
//
//    // MARK: - Touch Events
//
//    // initialize the blade at touch location
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let touchLocation = touch.location(in: self)
//        presentBladeAtPosition(touchLocation)
//    }
//
//    // delta value will help you later to properly update the blade position,
//    // Calculate the difference between currentPoint and previousPosition and store that value in delta
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let currentPoint = touch.location(in: self)
//        let previousPoint = touch.previousLocation(in: self)
//        delta = CGPoint(x: currentPoint.x - previousPoint.x, y: currentPoint.y - previousPoint.y)
//    }
//
//    // Remove the Blade if the touches have been cancelled or ended
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeBlade()
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeBlade()
//    }
//
//    // MARK: - FPS
//
//    override func update(_ currentTime: TimeInterval) {
//        // if the blade is not available return
//        guard let blade = blade else {
//            return
//        }
//
//        // Here you add the delta value to the blade position
//        let newPosition = CGPoint(x: blade.position.x + delta.x, y: blade.position.y + delta.y)
//        // Set the new position
//        blade.position = newPosition
//        // it's important to reset delta at this point,
//        // You are telling the blade to only update his position when touchesMoved is called
//        delta = .zero
//    }
//
//}
