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

/* GameObject encapsulates an SKSpriteNode to make it easier to work with */
class GameObject: SKSpriteNode {
    let type: GameObjectType

    /* Initialises the sprite with the properties specified in the dictionary */
    init (type: GameObjectType, properties p: GameConfig.LevelConfig.GameObjectConfig) {
        self.type = type
        let texture = SKTexture(imageNamed: p.image)
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: p.size_width, height: p.size_height))
        name = p.name
        if let x = p.position_x, let y = p.position_y {
            position.x = CGFloat(x)
            position.y = CGFloat(y)
        }
        zPosition = CGFloat(p.position_z)
    }

    required init?(coder aDecoder: NSCoder) {
        self.type = GameObjectType.None
        super.init(coder: aDecoder)
    }
}
