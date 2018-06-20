//
//  GameObject.swift
//  tooth-ninja
//
//  Created by David Lopez on 9/6/18.
//  Copyright © 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit

enum GameObjectType {
    case Tooth
    case Other
    case None
}

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let External     : UInt32 = 0x1 << 1
    static let Player       : UInt32 = 0x1 << 2
}

/* GameObject encapsulates an SKSpriteNode to make it easier to work with.
 * Also assigns actions to game objects
 */
class GameObject: SKSpriteNode {
    let gameObjectType: GameObjectType

    /* Initialises the sprite with the properties specified in the properties */
    init (type: GameObjectType, properties p: GameConfigurationDecodable.LevelConfig.GameObjectConfig) {
        self.gameObjectType = type
        let texture = SKTexture(imageNamed: p.image)
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: p.size_width, height: p.size_height))
        name = p.name
        if let x = p.position_x, let y = p.position_y, let screenSize = GameConfiguration.screenSize {
            position.x = screenSize.width * CGFloat(x)
            position.y = screenSize.height * CGFloat(y)
        }
        zPosition = CGFloat(p.position_z)
        setUpPhysics()
    }

    init (type: GameObjectType, texture: SKTexture, size: CGSize) {
        self.gameObjectType = type
        super.init(texture: texture, color: UIColor.clear, size: size)
    }

    // TODO (1): This should be done by name and not by type.
    func setUpPhysics(){
        switch gameObjectType {
            case .Tooth:
                addRectPhysicsBody(
                    categoryBitMask: PhysicsCategory.Player,
                    contactTestBitMask: PhysicsCategory.External,
                    collisionBitMask: PhysicsCategory.None)
            case .Other:
                // This one is meant for bacteria and food
                addCircularPhysicsBody(
                        categoryBitMask: PhysicsCategory.External,
                        contactTestBitMask: PhysicsCategory.Player,
                        collisionBitMask: PhysicsCategory.None)
            case .None:
                return
        }
    }

    func addRectPhysicsBody(categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){

        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = contactTestBitMask
        physicsBody?.collisionBitMask = collisionBitMask
        physicsBody?.usesPreciseCollisionDetection = true
    }

    func addCircularPhysicsBody(categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){

        let radius = max(size.width/2, size.height/2)

        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = contactTestBitMask
        physicsBody?.collisionBitMask = collisionBitMask
        physicsBody?.usesPreciseCollisionDetection = true
    }

    required init?(coder aDecoder: NSCoder) {
        self.gameObjectType = GameObjectType.None
        super.init(coder: aDecoder)
    }

    /* Creates a new object with same details */
    override func copy(with zone: NSZone?) -> Any {
        let copy = GameObject(type: gameObjectType, texture: texture!, size: size)
        copy.name = name
        print("original object position is \(position)")
        copy.position = position
        copy.zPosition = zPosition
        copy.physicsBody = physicsBody?.copy() as? SKPhysicsBody

        return copy
    }
}
