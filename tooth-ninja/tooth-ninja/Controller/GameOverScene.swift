//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by David Lopez on 13/4/18.
//  Copyright © 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {

    init(size: CGSize, won:Bool, nextScene: SKScene) {

        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.white

        // 2
        let message = won ? "Well done! You’ve kept your child’s teeth and clean and balanced their diet appropriately! Keep this up!" : "Sorry, your child’s tooth received too much decay from the bacteria! Try again!"

        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        
        
        label.text = message
        label.fontSize = 15
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)

        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                // 5
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                self.view?.presentScene(nextScene, transition:reveal)
            }
            ]))

    }

    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

