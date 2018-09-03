//
//  GameViewController.swift
//  tooth-ninja
//
//  Created by David Lopez and Kushagra Vashisht on 7/10/18.

import UIKit
import SpriteKit

protocol Controller {
    var healthBar: UIView {get}
    var happinessBar: UIView {get}
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLayout()
        
        menuButton.backgroundColor = .clear
        menuButton.layer.cornerRadius = 5
        menuButton.layer.borderWidth = 1
        menuButton.layer.borderColor = UIColor.white.cgColor
        
        // ADDING THE HIDDEN VIEW CONTROLS FOR THE LONG PRESS GESTURE RECOGNISER HERE
//        let longPressGestRecg = UILongPressGestureRecognizer(target: self, action: #selector(openMenu(press:)))
//        longPressGestRecg.minimumPressDuration = 3.0
//
//        hiddenView.addGestureRecognizer(longPressGestRecg)

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

        let teethArray = config!.getTeethByLevel(id: 1)
        let bacteriaArray = config!.getObjectsByLevel(id: 1, name: "bacteria")
        let foodArray = config!.getObjectsByLevel(id: 1, name: "food")
        print(bacteriaArray[0])
        // Use the JSON file to open level 1
        currentLevel = Level(number: 1, size: skView!.bounds.size, bgFile: "background2.png",
                             teethArray: teethArray, bacteriaArray: bacteriaArray, foodArray: foodArray,  c: self)

        currentLevel?.scaleMode = SKSceneScaleMode.resizeFill

        skView!.presentScene(currentLevel)
    }
    
    let healthBar: UIView =
    {
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor(red:0.88, green:0.16, blue:0.42, alpha:1.0)
        return bar
    }()
    
    let happinessBar: UIView =
    {
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor(red:0.36, green:0.60, blue:0.88, alpha:1.0)
        return bar
    }()
    
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
        currentLevel = Level(number: nextLevelId, size: currentLevel!.size, bgFile: currentLevel!.backgroundFile!, teethArray: newTeethArray,
                             bacteriaArray: newBacteriaArray, foodArray: newFoodArray, c: self)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        print("HERE")
        self.healthBar.isHidden = true
        self.happinessBar.isHidden = true
        let gameOverScene = GameOverScene(size: currentLevel!.size, won: won, nextScene: currentLevel!)
        skView?.presentScene(gameOverScene, transition: reveal)
    }
    
    private func setupLayout()
    {
        let whiteView = UIView()
        whiteView.backgroundColor = .clear
        
        let bottomControlsContainer = UIStackView(arrangedSubviews: [healthBar, whiteView, happinessBar])
        
        bottomControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsContainer.distribution = .fillEqually

        view.addSubview(bottomControlsContainer)
        
        bottomControlsContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomControlsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomControlsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomControlsContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bottomControlsContainer.spacing = 100
    }

    
    
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func goToStartingScreen(button: UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let hiddenViewController = storyBoard.instantiateViewController(withIdentifier: "StartingViewController")
        self.present(hiddenViewController, animated: true, completion: nil)
    }
}

