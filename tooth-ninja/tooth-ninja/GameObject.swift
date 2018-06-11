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

enum GameObjectError: Error {
    case PropertyDoesNotExist
}
//
//class GameObjectFactory {
//
//    func dictionaryToGameObject () -> GameObject {
//
//    }
//}

struct Properties {
    static let IMAGE_NAME = "image"
    static let NAME = "tag"
    static let SIZE_HEIGHT = "size_height"
    static let SIZE_WIDTH = "size_width"
    static let POSITION_X = "position_x"
    static let POSITION_Y = "position_y"
    static let POSITION_Z = "position_z"
}

/* GameObject encapsulates an SKSpriteNode to make it easier to work with */
class GameObject: SKSpriteNode {
    let type: GameObjectType

    /* Initialises the sprite with the properties specified in the dictionary */
    init (type: GameObjectType, properties p: Dictionary<String, AnyObject>) throws {

        if let imageName = p[Properties.IMAGE_NAME] as? String,
           let newName   = p[Properties.NAME] as? String,
           let height    = p[Properties.SIZE_HEIGHT] as? CGFloat,
           let width     = p[Properties.SIZE_WIDTH] as? CGFloat,
           let x         = p[Properties.POSITION_X] as? CGFloat,
           let y         = p[Properties.POSITION_Y] as? CGFloat,
           let z         = p[Properties.POSITION_Z] as? CGFloat
        {
            self.type = type
            let texture = SKTexture(imageNamed: imageName)
            super.init(texture: texture, color: UIColor.clear, size: CGSize(width: width, height: height))
            name = newName
            position.x = x
            position.y = y
            zPosition = z


        }else {
            throw GameObjectError.PropertyDoesNotExist
        }
    }

    required init?(coder aDecoder: NSCoder) {
        self.type = GameObjectType.None
        super.init(coder: aDecoder)
    }
}
