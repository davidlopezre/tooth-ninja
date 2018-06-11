//
//  GameViewController.swift
//  tooth-ninja
//
//  Created by David Lopez on 7/4/18.
//  Copyright © 2018 David Lopez. All rights reserved.
//

import UIKit
import SpriteKit

protocol Controller {
    func levelCompleted()
    func levelFailed()
}

class GameViewController: UIViewController, Controller {
    var currentLevel: Level? = nil
    var jsonLvlParser: JSONLevelParser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var go: GameObject? = nil
        let dictionary = [Properties.IMAGE_NAME: "tooth_1", Properties.NAME: "tooth", Properties.SIZE_HEIGHT: 50,
                          Properties.SIZE_WIDTH: 50, Properties.POSITION_X: 100, Properties.POSITION_Y: 100, Properties.POSITION_Z: 2] as [String : AnyObject]

        do {
            jsonLvlParser = try JSONLevelParser(fileName: "level_json_sample")
            go = try GameObject(type: GameObjectType.Tooth, properties: dictionary)

        }catch {
            print("Level cannot be loaded!")
        }

        let skView = initialiseSKView()

//        let teethArray = jsonLvlParser?.getTeeth()



        // let otherArray = jsonLvlParser?.getOther()
        // Use the JSON file to open level 1
        currentLevel = Level(size: skView.bounds.size, bgFile: "background2.png",
                teethArray: [go!], c: self)

        currentLevel?.scaleMode = SKSceneScaleMode.resizeFill

        skView.presentScene(currentLevel)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    /* Initialises the SKView where we display the game */
    private func initialiseSKView() -> SKView {
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.isMultipleTouchEnabled = false
        return skView
    }

    /* This method is called by the currentLevel when it is completed */
    func levelCompleted() {
        // check if there exists a higher level than currentLevel.id
        // change to next level or present winning screen
    }

    /* This method is called by the currentLevel when it is failed */
    func levelFailed() {
        // present losing screen
    }
    
}

