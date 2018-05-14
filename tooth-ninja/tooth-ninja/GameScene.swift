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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    // This optional variable will help you to easily access the blade
    var blade: SwipeNode?
    
    // This will help you to update the position of the blade
    // Set the initial value to 0
    var delta: CGPoint = .zero
    
    let tooth = SKShapeNode(circleOfRadius: 20.0)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.magenta
        
        tooth.fillColor = SKColor.white
        tooth.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        
        tooth.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        tooth.physicsBody?.isDynamic = true
        tooth.physicsBody?.categoryBitMask = PhysicsCategory.Tooth
        tooth.physicsBody?.contactTestBitMask = PhysicsCategory.Bacteria
        tooth.physicsBody?.collisionBitMask = PhysicsCategory.None
        tooth.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(tooth)
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(addBacteria),
            SKAction.wait(forDuration: 5.0)
            ])
        ))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addBacteria() {
        
        // Create sprite
        let bacteria = SKShapeNode(circleOfRadius: 20.0)
        
        
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
        let actionMove = SKAction.move(to: tooth.position, duration: TimeInterval(actualDuration))

        bacteria.run(actionMove)
    }
    
    func bacteriaCollidesWithTooth(bacteria: SKShapeNode) {
        print("Collision")
        bacteria.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var bacteriaBody: SKPhysicsBody
        
        let c = contact
        print("body a bitmask: \(c.bodyA.categoryBitMask)")
        print("body b bitmask: \(c.bodyB.categoryBitMask)")
        if c.bodyA.categoryBitMask > c.bodyB.categoryBitMask {
            bacteriaBody = c.bodyB
        } else {
            bacteriaBody = c.bodyA
        }
        print("bacteria body is set to: \(bacteriaBody.categoryBitMask)")
        
        if (bacteriaBody.categoryBitMask & PhysicsCategory.Bacteria != 0) {
            print("bacteria body confirmed")
            if let bacteria = bacteriaBody.node as? SKShapeNode {
                print("bacteria is a SKShapeNode")
                bacteriaCollidesWithTooth(bacteria: bacteria)
            }
        }
    }
    
    // This will help you to initialize our blade
    func presentBladeAtPosition(_ position:CGPoint) {
        blade = SwipeNode(position: position, target: self, color: .white)
        
        guard let blade = blade else {
            fatalError("Blade could not be created")
        }
        
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
