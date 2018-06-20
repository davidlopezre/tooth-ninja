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

/* GameViewController is in charge of managing the game. This includes creating and
 * changing levels, access to main menu, etc.
 */
class GameViewController: UIViewController, Controller {
    var currentLevel: Level? = nil
    var config: GameConfiguration?
    var skView: SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = initialiseSKView()
        do {
            config = try GameConfiguration(file: "level_json_sample", size: skView.bounds.size)

        }catch let error{
            print("Level cannot be loaded!")
            print(error)
        }

        let teethArray = config!.getTeethByLevel(id: 1)
        let objectArray = config!.getObjectsByLevel(id: 1)
        print(objectArray[0])
        // Use the JSON file to open level 1
        currentLevel = Level(size: skView.bounds.size, bgFile: "background2.png",
                teethArray: teethArray, otherArray: objectArray, c: self)

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
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: skView!.bounds.size, won: false)
        skView?.presentScene(gameOverScene, transition: reveal)
    }

    /* This method is called by the currentLevel when it is failed */
    func levelFailed() {
        // present losing screen
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: skView!.bounds.size, won: false)
        skView?.presentScene(gameOverScene, transition: reveal)
    }
    
}

