//
//  GameViewController.swift
//  tooth-ninja
//
//  Created by David Lopez and Kushagra Vashisht on 7/10/18.

import UIKit
import SpriteKit
import AVFoundation

protocol Controller {
    func levelEnd(won: Bool)
}

/* GameViewController is in charge of managing the game. This includes creating and
 * changing levels, access to main menu, etc.
 */
class GameViewController: UIViewController, Controller
{
    //health bar for the game
    var currentLevel: Level? = nil
    var config: GameConfiguration?
    var skView: SKView?
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Off Limits", ofType: "wav")!))
            audioPlayer.prepareToPlay()
            audioPlayer.pause()
            print("Music Player Paused in GameViewController")
        }
        catch
        {
            print(error)
        }
        
        menuButton.backgroundColor = niceBlue
        menuButton.layer.cornerRadius = 5
        menuButton.layer.borderWidth = 1
        menuButton.layer.borderColor = UIColor.white.cgColor
        skView = initialiseSKView()
        do
        {
            config = try GameConfiguration(file: "level_json_sample", size: skView!.bounds.size)
        }
        catch let error
        {
            print("Level cannot be loaded!")
            print(error)
        }
//        if(audioPlayer.isPlaying)
//        {
//            audioPlayer.pause()
//            print("Music Player Paused in GameViewController")
//        }

        let teethArray = config!.getTeethByLevel(id: 1)
        let bacteriaArray = config!.getObjectsByLevel(id: 1, name: "bacteria")
        let foodArray = config!.getObjectsByLevel(id: 1, name: "food")
        let score = config!.getScoreByLevel(id: 1)
        let icon = config!.getToothBrushIconByLevel(id: 1)
        // Use the JSON file to open level 1
        currentLevel = Level(number: 1, winningScore: score, icon: icon, size: skView!.bounds.size, bgFile: "background2.png",
                             teethArray: teethArray, bacteriaArray: bacteriaArray, foodArray: foodArray,  c: self)

        currentLevel?.scaleMode = SKSceneScaleMode.resizeFill

        skView!.presentScene(currentLevel)
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }

    /* Initialises the SKView where we display the game */
    private func initialiseSKView() -> SKView
    {
        let skView = view as! SKView
        skView.showsPhysics = false
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
        let newBacteriaArray = config!.getObjectsByLevel(id: nextLevelId, name: "bacteria")
        let newFoodArray = config!.getObjectsByLevel(id: nextLevelId, name: "food")
        let score = config!.getScoreByLevel(id: nextLevelId)
        let icon = config!.getToothBrushIconByLevel(id: nextLevelId)
        currentLevel = Level(number: nextLevelId, winningScore: score, icon: icon, size: currentLevel!.size, bgFile: currentLevel!.backgroundFile!, teethArray: newTeethArray,
                             bacteriaArray: newBacteriaArray, foodArray: newFoodArray, c: self)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: currentLevel!.size, won: won, nextScene: currentLevel!)
        skView?.presentScene(gameOverScene, transition: reveal)
    }

    @IBOutlet weak var menuButton: UIButton!
    @IBAction func goToStartingScreen(button: UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let hiddenViewController = storyBoard.instantiateViewController(withIdentifier: "StartingViewController")
        self.present(hiddenViewController, animated: true, completion: nil)
    }
    
    
}

