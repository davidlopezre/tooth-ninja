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
    func levelEnd(won: Bool)
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

        skView = initialiseSKView()
        
        do {
            config = try GameConfiguration(file: "level_json_sample", size: skView!.bounds.size)

        }catch let error{
            print("Level cannot be loaded!")
            print(error)
        }

        let teethArray = config!.getTeethByLevel(id: 1)
        let objectArray = config!.getObjectsByLevel(id: 1)
        print(objectArray[0])
        // Use the JSON file to open level 1
        currentLevel = Level(number: 1, size: skView!.bounds.size, bgFile: "background2.png",
                teethArray: teethArray, otherArray: objectArray, c: self)

        currentLevel?.scaleMode = SKSceneScaleMode.resizeFill

        skView!.presentScene(currentLevel)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    /* Initialises the SKView where we display the game */
    private func initialiseSKView() -> SKView {
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsPhysics = false
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.isMultipleTouchEnabled = false
        return skView
    }

    /* This method is called by the currentLevel when it is completed */
    func levelEnd(won: Bool) {
        let nextLevelId : Int
        // TODO (4) : This just loops on level 3 forever
        if (won && currentLevel!.number < 3) {
            nextLevelId = currentLevel!.number + 1
        }else{
            nextLevelId = currentLevel!.number
        }

        currentLevel!.removeAllChildren()

        let newTeethArray = config!.getTeethByLevel(id: nextLevelId)
        let newOtherArray = config!.getObjectsByLevel(id: nextLevelId)
        currentLevel = Level(number: nextLevelId, size: currentLevel!.size, bgFile: currentLevel!.backgroundFile!, teethArray: newTeethArray,
                otherArray: newOtherArray, c: self)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: currentLevel!.size, won: won, nextScene: currentLevel!)
        skView?.presentScene(gameOverScene, transition: reveal)

    }
    
}

