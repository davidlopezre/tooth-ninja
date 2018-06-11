////
////  Bacteria.swift
////  tooth-ninja
////
////  Created by David Lopez on 4/6/18.
////  Copyright © 2018 David Lopez. All rights reserved.
////
//import SpriteKit
//import Foundation
//func addBacteria(scene: SKScene, completion: @escaping () -> Void) {
//    let size = CGSize(width: 50, height: 50)
//    let actualY = SpriteCreation.random(min: scene.size.height*0.1, max: scene.size.height*0.9)
//    let actualX = SpriteCreation.random(min: scene.size.width*0.1, max: scene.size.width*0.9)
//    let actualPosition = CGPoint(x: actualX, y: actualY)
//
//    let bacteria = SpriteCreation.createGameElement(imageName: "bacteria_blue", name: "bacteria", size: size, position: actualPosition, zPosition: 2)
//
//    SpriteCreation.addCircularPhysicsBody(target: bacteria, circleRadius: max(bacteria.size.width/2, bacteria.size.height/2), categoryBitMask: PhysicsCategory.External, contactTestBitMask: PhysicsCategory.Player, collisionBitMask: PhysicsCategory.None)
//
//    SpriteCreation.addToScene(sprite: bacteria, scene: scene)
//
//
//    // Determine speed of the monster
//    let actualDuration = SpriteCreation.random(min: CGFloat(8.0), max: CGFloat(10.0))
//
//    // Create the actions
//    let teeth = scene["tooth"]
//    print("There are \(teeth.count) teeth")
//
//    let targetToothIndex = SpriteCreation.random(min: 0, max: CGFloat(teeth.count))
//    let targetTooth = teeth[Int(targetToothIndex)]
//
//    let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))
//
//    bacteria.run(actionMove)
//}
//
//func addBacteria2(scene: SKScene, completion: @escaping () -> Void) {
//    let size = CGSize(width: 50, height: 50)
//    let actualY = SpriteCreation.random(min: scene.size.height*0.1, max: scene.size.height*0.9)
//    let actualX = SpriteCreation.random(min: scene.size.width*0.1, max: scene.size.width*0.9)
//    let actualPosition = CGPoint(x: actualX, y: actualY)
//
//    let bacteria = SpriteCreation.createGameElement(imageName: "bacteria_yellow", name: "bacteria2", size: size, position: actualPosition, zPosition: 2)
//
//    SpriteCreation.addCircularPhysicsBody(target: bacteria, circleRadius: max(bacteria.size.width/2, bacteria.size.height/2), categoryBitMask: PhysicsCategory.External, contactTestBitMask: PhysicsCategory.Player, collisionBitMask: PhysicsCategory.None)
//
//    SpriteCreation.addToScene(sprite: bacteria, scene: scene)
//
//
//    // Determine speed of the monster
//    let actualDuration = SpriteCreation.random(min: CGFloat(8.0), max: CGFloat(10.0))
//
//    // Create the actions
//    let teeth = scene["tooth"]
//    print("There are \(teeth.count) teeth")
//
//    let targetToothIndex = SpriteCreation.random(min: 0, max: CGFloat(teeth.count))
//    let targetTooth = teeth[Int(targetToothIndex)]
//
//    let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))
//
//    bacteria.run(actionMove)
//}
