////
////  Tooth.swift
////  tooth-ninja
////
////  Created by David Lopez on 4/6/18.
////  Copyright © 2018 David Lopez. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//class Tooth {
//    static func addTooth(position: CGPoint, scene: SKScene) {
//        let size = CGSize(width: 90, height: 90)
//        let tooth = SpriteCreation.createGameElement(imageName: "tooth_1", name: "tooth", size: size, position: position, zPosition: 2)
//        SpriteCreation.addRectPhysicsBody(target: tooth, rectSize: tooth.size, categoryBitMask: PhysicsCategory.Player, contactTestBitMask: PhysicsCategory.External, collisionBitMask: PhysicsCategory.None)
//        SpriteCreation.addToScene(sprite: tooth, scene: scene)
//    }
//}
