//
//  GameViewController.swift
//  tooth-ninja
//
//  Created by David Lopez and Kushagra Vashisht on 7/10/18.

import UIKit
import SpriteKit

protocol Controller {
    func levelEnd(won: Bool)
}

/* GameViewController is in charge of managing the game. This includes creating and
 * changing levels, access to main menu, etc.
 */
class GameViewController: UIViewController, Controller {
    
    
    @IBOutlet var healthBar: UIView!
    //health bar for the game
    
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
        currentLevel = Level(size: skView!.bounds.size, bgFile: "background2.png",
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
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.isMultipleTouchEnabled = false
        return skView
    }

    /* This method is called by the currentLevel when it is completed */
    func levelEnd(won: Bool) {
        currentLevel!.removeAllChildren()
        let newTeethArray = copyArray(array: currentLevel!.teethArray) as! [GameObject]
        let newOtherArray = copyArray(array: currentLevel!.otherArray) as! [GameObject]
        let nextLevel = Level(size: currentLevel!.size, bgFile: currentLevel!.backgroundFile!, teethArray: newTeethArray,
                otherArray: newOtherArray, c: self)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: currentLevel!.size, won: won, nextScene: nextLevel)
        skView?.presentScene(gameOverScene, transition: reveal)

    }
    
}

