//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by David Lopez and Kushagra Vashisht on 13/4/18.
//  Copyright © 2018 David Lopez and Kushagra Vashisht. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TextTransitionScene: SKScene {
    var audioPlayer = AVAudioPlayer()
    var nextScene : SKScene?

    init(size: CGSize, text: String, nextScene: SKScene) {
        self.nextScene = nextScene
        super.init(size: size)
        
        if let level = nextScene as? Level {
            switch level.number {
            case 1:
                let bacteria = SKSpriteNode(imageNamed: "bacteria_blue")
                bacteria.size = CGSize(width: 50, height: 50)
                bacteria.zPosition = 1
                bacteria.position = CGPoint(x: size.width/2, y: size.height/4)
                self.addChild(bacteria)
            case 2:
                let otherBacteria = SKSpriteNode(imageNamed: "bacteria_yellow")
                otherBacteria.size = CGSize(width: 50, height: 50)
                otherBacteria.zPosition = 1
                otherBacteria.position = CGPoint(x: size.width/2, y: size.height - 50)
                self.addChild(otherBacteria)
                
                let chocolate = SKSpriteNode(imageNamed: "chocolate")
                chocolate.size = CGSize(width: 50, height: 50)
                chocolate.zPosition = 1
                chocolate.position = CGPoint(x: size.width/2 - 200, y: size.height - 150)
                self.addChild(chocolate)
                
                let juice = SKSpriteNode(imageNamed: "food_fruit_juice")
                juice.size = CGSize(width: 50, height: 50)
                juice.zPosition = 1
                juice.position = CGPoint(x: size.width/2 + 175, y: size.height - 150)
                self.addChild(juice)
                
                let milk = SKSpriteNode(imageNamed: "food_milk")
                milk.size = CGSize(width: 50, height: 50)
                milk.zPosition = 1
                milk.position = CGPoint(x: size.width/2 + 200, y: size.height - 250)
                self.addChild(milk)
                
                let cheese = SKSpriteNode(imageNamed: "food_cheese2")
                cheese.size = CGSize(width: 50, height: 50)
                cheese.zPosition = 1
                cheese.position = CGPoint(x: size.width/2 - 200, y: size.height - 250)
                self.addChild(cheese)
                
                let water = SKSpriteNode(imageNamed: "food_tap")
                water.size = CGSize(width: 50, height: 50)
                water.zPosition = 1
                water.position = CGPoint(x: size.width/2 + 50, y: size.height - 300)
                self.addChild(water)
                
                let bottle = SKSpriteNode(imageNamed: "food_water")
                bottle.size = CGSize(width: 50, height: 50)
                bottle.zPosition = 1
                bottle.position = CGPoint(x: size.width/2 - 80, y: size.height - 300)
                self.addChild(bottle)
            case 3:
                let cola = SKSpriteNode(imageNamed: "cola")
                cola.size = CGSize(width: 30, height: 50)
                cola.zPosition = 1
                cola.position = CGPoint(x: size.width/2 - 200, y: size.height - 50)
                self.addChild(cola)
                
                let dark = SKSpriteNode(imageNamed: "food_dark_chocolate")
                dark.size = CGSize(width: 30, height: 50)
                dark.zPosition = 1
                dark.position = CGPoint(x: size.width/2 + 175, y: size.height - 50)
                self.addChild(dark)
                
                let sugarfree = SKSpriteNode(imageNamed: "food_cola")
                sugarfree.size = CGSize(width: 30, height: 50)
                sugarfree.zPosition = 1
                sugarfree.position = CGPoint(x: size.width/2 + 200, y: size.height/2 - 150)
                self.addChild(sugarfree)
                
                let toothpaste = SKSpriteNode(imageNamed: "tooth_paste")
                toothpaste.size = CGSize(width: 35, height: 50)
                toothpaste.zPosition = 1
                toothpaste.position = CGPoint(x: size.width/2 - 200, y: size.height/2 - 150)
                self.addChild(toothpaste)
                
            default:
                break
            }
        }
        
        backgroundColor = SKColor.white

        // 2
        let message = text
        // 3
        
        let textBlock = createMultiLineText(textToPrint: message, color: SKColor.black, fontSize: 15, fontName: "Chalkduster", fontPosition: CGPoint(x: size.width/2, y: size.height/2), fontLineSpace: 23)
        textBlock.zPosition = 2
        addChild(textBlock)
        
        let duration : Double
        if text.count > 76 {
            duration = 15.0
        } else {
            duration = 3.0
        }

        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: duration),
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAllActions()
        run(SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            if let scene = self.nextScene {
                self.view?.presentScene(scene, transition:reveal)
            } else {
                return
            }})
        super.touchesBegan(touches, with: event)
    }
    
    func createMultiLineText(textToPrint:String, color:UIColor, fontSize:CGFloat, fontName:String, fontPosition:CGPoint, fontLineSpace:CGFloat)->SKNode{
        
        // create node to hold the text block
        let textBlock = SKNode()
        
        //create array to hold each line
        let textArr = textToPrint.components(separatedBy: "\n")
        
        // loop through each line and place it in an SKNode
        var lineNode: SKLabelNode
        for line: String in textArr {
            lineNode = SKLabelNode(fontNamed: fontName)
            lineNode.text = line
            lineNode.fontSize = fontSize
            lineNode.fontColor = color
            lineNode.fontName = fontName
            lineNode.position = CGPoint(x: fontPosition.x, y : fontPosition.y - CGFloat(textBlock.children.count ) * fontSize + fontLineSpace)
            textBlock.addChild(lineNode)
        }
        
        // return the sknode with all of the text in it
        return textBlock
    }
}

