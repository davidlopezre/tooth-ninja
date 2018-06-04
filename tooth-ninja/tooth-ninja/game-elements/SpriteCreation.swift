//
//  Tooth.swift
//  tooth-ninja
//
//  Created by David Lopez on 4/6/18.
//  Copyright © 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit
class SpriteCreation {
    static func createGameElement(imageName: String, name: String, size: CGSize, position: CGPoint, zPosition: CGFloat) -> SKSpriteNode {
        let ge = SKSpriteNode(imageNamed: imageName)
        ge.name = name
        ge.size = size
        ge.position = position
        ge.zPosition = zPosition
        return ge
    }
    //dhdhhdhdhd
    
    static func addRectPhysicsBody(target: SKSpriteNode, rectSize: CGSize, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){
        
        target.physicsBody = SKPhysicsBody(rectangleOf: rectSize)
        target.physicsBody?.isDynamic = true
        target.physicsBody?.categoryBitMask = categoryBitMask
        target.physicsBody?.contactTestBitMask = contactTestBitMask
        target.physicsBody?.collisionBitMask = collisionBitMask
        target.physicsBody?.usesPreciseCollisionDetection = true
    }

    static func addCircularPhysicsBody(target: SKSpriteNode, circleRadius: CGFloat, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){
        
        target.physicsBody = SKPhysicsBody(circleOfRadius: circleRadius)
        target.physicsBody?.isDynamic = true
        target.physicsBody?.categoryBitMask = categoryBitMask
        target.physicsBody?.contactTestBitMask = contactTestBitMask
        target.physicsBody?.collisionBitMask = collisionBitMask
        target.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    static func addToScene(sprite: SKSpriteNode, scene: SKScene) {
        scene.addChild(sprite)
    }
    
    static func doAction(sprite: SKSpriteNode, action: SKAction){}
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
