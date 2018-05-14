//
//  GameScene.swift
//  tooth-ninja
//
//  Created by David Lopez on 7/4/18.
//  Copyright © 2018 David Lopez. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None        : UInt32 = 0
    static let All         : UInt32 = UInt32.max
    static let Bacteria    : UInt32 = 0b1
    static let Tooth       : UInt32 = 0b10
    static let Swipe       : UInt32 = 0b11
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var healthLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var health = 100 {
        didSet {
            healthLabel.text = "HP: \(health)%"
        }
    }
    
    // This optional variable will help you to easily access the blade
    var blade: SwipeNode?
    
    // This will help you to update the position of the blade
    // Set the initial value to 0
    var delta: CGPoint = .zero
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.magenta
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
//        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.fontSize = 25
        scoreLabel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        addChild(scoreLabel)
        
        healthLabel = SKLabelNode(fontNamed: "Chalkduster")
        healthLabel.text = "HP: 100%"
        healthLabel.fontSize = 25
        healthLabel.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        addChild(healthLabel)
        
        addTooth(position: CGPoint(x: size.width * 0.5, y: size.height * 0.9))
        addTooth(position: CGPoint(x: size.width * 0.5, y: size.height * 0.1))
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(addBacteria),
            SKAction.run(addBacteria),
            SKAction.wait(forDuration: 2.0)
            ])
        ))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addTooth(position: CGPoint) {
        
        let tooth = SKShapeNode(circleOfRadius: 20.0)
        
        tooth.name = "tooth"
        tooth.fillColor = SKColor.white
        tooth.position = position
        
        tooth.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        tooth.physicsBody?.isDynamic = true
        tooth.physicsBody?.categoryBitMask = PhysicsCategory.Tooth
        tooth.physicsBody?.contactTestBitMask = PhysicsCategory.Bacteria
        tooth.physicsBody?.collisionBitMask = PhysicsCategory.None
        tooth.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(tooth)
    }
    
    func addBacteria() {
        
        // Create sprite
        let bacteria = SKShapeNode(circleOfRadius: 20.0)
        bacteria.name = "bacteria"
        
        bacteria.fillColor = SKColor.green
        
        let actualY = random(min: size.height*0.1, max: size.height*0.9)
        let actualX = random(min: size.width*0.1, max: size.width*0.9)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        bacteria.position = CGPoint(x: actualX, y: actualY)
        
        bacteria.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        bacteria.physicsBody?.isDynamic = true
        bacteria.physicsBody?.categoryBitMask = PhysicsCategory.Bacteria
        bacteria.physicsBody?.contactTestBitMask = PhysicsCategory.Tooth
        bacteria.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Add the bacteria to the scene
        addChild(bacteria)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let teeth = self["tooth"]
        print("There are \(teeth.count) teeth")
        
        let targetToothIndex = random(min: 0, max: CGFloat(teeth.count))
        let targetTooth = teeth[Int(targetToothIndex)]
        
        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))

        bacteria.run(actionMove)
    }
    
    func bacteriaCollidesWithTooth(bacteria: SKShapeNode) {
        print("Collision: Bacteria-Tooth")
        bacteria.removeFromParent()
        health -= 25
        if (health <= 0) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func swipeCollidesWithBacteria(bacteria: SKShapeNode) {
        print("Collision: Swipe-Bacteria")
        bacteria.removeFromParent()
        score += 1
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var bacteriaBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        
        print("body a bitmask: \(contact.bodyA.categoryBitMask)")
        print("body b bitmask: \(contact.bodyB.categoryBitMask)")
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            bacteriaBody = contact.bodyB
            otherBody = contact.bodyA
        } else {
            bacteriaBody = contact.bodyA
            otherBody = contact.bodyB
        }
        print("bacteria body is set to: \(bacteriaBody.categoryBitMask)")
        print("other body is set to: \(otherBody.categoryBitMask)")
        
        if ((bacteriaBody.node?.name == "bacteria") && (otherBody.node?.name == "tooth")) {
            print("bacteria-tooth collision confirmed")
            print("other body is \(String(describing: otherBody.node?.name))")
            if let bacteria = bacteriaBody.node as? SKShapeNode {
                bacteriaCollidesWithTooth(bacteria: bacteria)
            }
        } else if ((bacteriaBody.node?.name == "bacteria") && (otherBody.node?.name == "swipe")) {
            print("bacteria-swipe collision confirmed")
            if let bacteria = bacteriaBody.node as? SKShapeNode {
                swipeCollidesWithBacteria(bacteria: bacteria)
            }
        }
    }
    
    // This will help you to initialize our blade
    func presentBladeAtPosition(_ position:CGPoint) {
        blade = SwipeNode(position: position, target: self, color: .white)
        
        guard let blade = blade else {
            fatalError("Blade could not be created")
        }
        blade.enablePhysics(categoryBitMask: PhysicsCategory.Swipe, contactTestBitmask: PhysicsCategory.Bacteria, collisionBitmask: PhysicsCategory.None)
        
        addChild(blade)
    }
    
    // This will help you to remove the blade and reset the delta value
    func removeBlade() {
        guard let blade = blade else {
            return
        }
        
        blade.removeFromParent()
        delta = .zero
    }
    
    // MARK: - Touch Events
    
    // initialize the blade at touch location
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        presentBladeAtPosition(touchLocation)
    }
    
    // delta value will help you later to properly update the blade position,
    // Calculate the difference between currentPoint and previousPosition and store that value in delta
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let currentPoint = touch.location(in: self)
        let previousPoint = touch.previousLocation(in: self)
        delta = CGPoint(x: currentPoint.x - previousPoint.x, y: currentPoint.y - previousPoint.y)
    }
    
    // Remove the Blade if the touches have been cancelled or ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeBlade()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeBlade()
    }
    
    // MARK: - FPS
    
    override func update(_ currentTime: TimeInterval) {
        // if the blade is not available return
        guard let blade = blade else {
            return
        }
        
        // Here you add the delta value to the blade position
        let newPosition = CGPoint(x: blade.position.x + delta.x, y: blade.position.y + delta.y)
        // Set the new position
        blade.position = newPosition
        // it's important to reset delta at this point,
        // You are telling the blade to only update his position when touchesMoved is called
        delta = .zero
    }
    
}
