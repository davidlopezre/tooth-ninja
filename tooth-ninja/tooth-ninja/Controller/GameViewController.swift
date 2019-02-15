//
//  GameViewController.swift
//  tooth-ninja
//
//  Created by David Lopez and Kushagra Vashisht on 7/10/18.

import UIKit
import SpriteKit
import AVFoundation

/* GameViewController is in charge of managing the game. This includes creating and
 * changing levels, access to main menu, etc.
 */
class GameViewController: UIViewController
{
    //health bar for the game
    var currentLevel: Level? = nil
    var config: GameConfiguration?
    var skView: SKView?
    var audioPlayer = AVAudioPlayer()
    var levelId: Int = 1
    
    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
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
        
        menuButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 2
        menuButton.addGestureRecognizer(tap)
        
        skView = initialiseSKView()
        do
        {
            config = try GameConfiguration(file: "level_json_sample", size: self.skView!.bounds.size)
        }
        catch let error
        {
            print("Level cannot be loaded!")
            print(error)
        }

        if skView?.scene == nil {
            let teethArray = config!.getTeethByLevel(id: levelId)
            let bacteriaArray = config!.getObjectsByLevel(id: levelId, name: "bacteria")
            let foodArray = config!.getObjectsByLevel(id: levelId, name: "food")
            let score = config!.getScoreByLevel(id: levelId)
            let icon = config!.getToothBrushIconByLevel(id: levelId)
            // Use the JSON file to open level 1
            currentLevel = Level(number: levelId, winningScore: score, icon: icon, size: skView!.bounds.size, bgFile: "background2.png",
                                 teethArray: teethArray, bacteriaArray: bacteriaArray, foodArray: foodArray,  c: self)

            currentLevel?.scaleMode = SKSceneScaleMode.resizeFill

            skView?.presentScene(presentLevel(level: currentLevel!))
        }
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }

    @objc func tapped() {
        print("2 times tapped")
        currentLevel = nil
        self.skView?.presentScene(nil)
        self.navigationController?.popViewController(animated: true)
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
        if (won && currentLevel!.number < 3) {
            nextLevelId = currentLevel!.number + 1
            setLevelUnlocked(id: nextLevelId)
        }else if (won && currentLevel!.number == 3) {
            self.navigationController?.popToRootViewController(animated: true)
            return
        } else {
            nextLevelId = currentLevel!.number
        }
        
        currentLevel?.removeAllChildren()
        let newTeethArray = config!.getTeethByLevel(id: nextLevelId)
        let newBacteriaArray = config!.getObjectsByLevel(id: nextLevelId, name: "bacteria")
        let newFoodArray = config!.getObjectsByLevel(id: nextLevelId, name: "food")
        let score = config!.getScoreByLevel(id: nextLevelId)
        let icon = config!.getToothBrushIconByLevel(id: nextLevelId)
        let nextLevel = Level(number: nextLevelId, winningScore: score, icon: icon, size: currentLevel!.size, bgFile: currentLevel!.backgroundFile!, teethArray: newTeethArray,
                             bacteriaArray: newBacteriaArray, foodArray: newFoodArray, c: self)
        currentLevel = nil
        currentLevel = nextLevel
        presentGameOverAndRestart(level: currentLevel!, won: won)
    }

    @IBOutlet weak var menuButton: UIButton!
    
    func presentLevel(level: Level) -> SKScene {
        let text : String
        if (level.number == 1) {
            text = TextConstants.BEGIN_LVL_1
        } else if (level.number == 2) {
            text = TextConstants.BEGIN_LVL_2
        } else {
            text = TextConstants.BEGIN_LVL_3
        }
        let preScene = TextTransitionScene(size: level.size, text: text, nextScene: level)
        return preScene
    }
    
    func presentGameOverAndRestart(level: Level, won: Bool) {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let text : String
        if (won) {
            text = TextConstants.WON_TEXT
        } else {
            text = TextConstants.LOST_TEXT
        }
        let gameOverScene = TextTransitionScene(size: level.size, text: text, nextScene: presentLevel(level: level))
        skView?.presentScene(gameOverScene, transition: reveal)
    }
    
    
    deinit {
         print("GameViewController deinited")
    }
}

