//
//  Level.swift includes all classes and protocols related to level
//  initialisation and running.
//
//  Created by David Lopez and Kushagra Vashisht on 9/6/18.
//  Copyright © 2018 David Lopez and Kushagra Vashisht. All rights reserved.
//

import Foundation
import SpriteKit

/* BaseLevel protocol includes the required fields and functions for a level */
protocol BaseLevel {
    var number: Int {get}
    var winningScore: Int {get}
    var icon: String {get}
    var controller: Controller? {get}
    var scoreLabel: SKLabelNode? {get}
    var healthLabel: SKLabelNode? {get}
    var happinessLabel: SKLabelNode? {get}
    var backgroundFile: String? {get}
    var teethArray: [GameObject] {get set}   // array of teeth in a level
    var bacteriaArray: [GameObject] {get set}   // array of possible objects in a level
    var foodArray: [GameObject] {get set}
    var levelExecution: LevelExecution! {get}
    var levelPhysics: LevelPhysics! {get}
}

protocol LevelController {
    var score: Int {get set}
    var health: Int {get set}
}

/* This extension provides functionality to make callbacks to the Controller */
extension BaseLevel {

    func levelEnd(won: Bool) {
        controller?.levelEnd(won: won)
    }
}

/* Level class is in charge of initialising, running the level and notifying the
 * controller of level completion or failure.
 */
class Level: SKScene, SKPhysicsContactDelegate, BaseLevel, LevelController {

    let number: Int
    let icon: String
    let winningScore: Int
    var controller: Controller?
    var scoreLabel: SKLabelNode?
    var healthLabel: SKLabelNode?
    var happinessLabel: SKLabelNode?
    var shieldLabel: SKLabelNode?
    var teethArray: [GameObject]
    var bacteriaArray: [GameObject]
    var foodArray: [GameObject]
    let backgroundFile: String?
    var levelExecution: LevelExecution!
    var levelPhysics: LevelPhysics!
    var healthBar : CustomBar!
    var happinessBar: CustomBar!
    
    var score = 0
    {
        didSet
        {
            scoreLabel?.text = "Score: \(score)"
        }
    }

    var health = 100
    {
        didSet
        {
            if health > 100
            {
                health = 100
            }
            else if (health < 0)
            {
                health = 0
            }
            healthLabel?.text = "Health " + ": \(health)%"
            
            let damage = Double(health)/100.0
            healthBar.setProgress(x: CGFloat(damage))
        }
    }

    var happiness = 100 {
        didSet {
            if happiness > 100 {
                happiness = 100
            }else if (happiness < 0) {
                happiness = 0
            }
            happinessLabel?.text = "Happiness : \(happiness)%"
            
            let damage = Double(happiness)/100.0
            happinessBar.setProgress(x: CGFloat(damage))
        }
    }

    // This optional variable will help you to easily access the blade
    var blade: SwipeNode?

    // This will help you to update the position of the blade
    // Set the initial value to 0
    var delta: CGPoint = .zero

    init(number: Int, winningScore: Int, icon: String, size: CGSize, bgFile: String, teethArray: [GameObject], bacteriaArray: [GameObject], foodArray: [GameObject], c: Controller) {
        self.number = number
        self.winningScore = winningScore
        self.icon = icon
        self.teethArray = teethArray
        self.controller = c
        self.backgroundFile = bgFile
        self.bacteriaArray = bacteriaArray
        self.foodArray = foodArray
        super.init(size: size)
        // use the JSON thing to give the level the game elements
    }

    required public init?(coder aDecoder: NSCoder) {
        number = 1
        winningScore = 200
        teethArray = []
        backgroundFile = nil
        bacteriaArray = []
        foodArray = []
        icon = "toothbrush_no_paste"
        super.init(coder: aDecoder)
    }

    deinit{print("GameScene deinited")}

    public override func didMove(to view: SKView) {
        levelExecution = LevelExecution(level: self, bacteria: bacteriaArray, food: foodArray)
        levelPhysics = LevelPhysics(level: self)
        addBackgroundAndWidgets()
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        for tooth in teethArray{
            addChild(tooth)
        }

        levelExecution.runLevel()
    }

    public func didBegin(_ contact: SKPhysicsContact) {
        levelPhysics.didBegin(contact)
    }

    /* Sets the background of the level and initialises the health and score bars and adds the
     tooth brush icon */
    func addBackgroundAndWidgets() {
        
        if let bgFile = backgroundFile {
            let background = SKSpriteNode(imageNamed: bgFile)
            background.zPosition = 1
            background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            background.size = size
            addChild(background)
        }

        // Not worth abstracting the part below as we will not be using labels forever anyways
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel!.text = "Score: 0"
        scoreLabel!.zPosition = 2
        scoreLabel!.fontSize = 20
        scoreLabel!.position = CGPoint(x: size.width * 0.9, y: size.height * 0.86)
        addChild(scoreLabel!)

        healthLabel = SKLabelNode(fontNamed: "Chalkduster")
        healthLabel!.text = "Health : 100%"
        healthLabel!.fontSize = 20
        healthLabel!.zPosition = 2
        healthLabel!.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.zPosition = 3
        heart.size = CGSize(width: 20, height: 20)
        heart.position = CGPoint(x: size.width * 0.02, y: size.height * 0.9)
        addChild(heart)
        
        healthBar = CustomBar(color: .red, size: CGSize(width: health, height: 15))
        healthBar.position = CGPoint(x: size.width * 0.05, y: size.height * 0.9)
        healthBar.zPosition = 3
        addChild(healthBar)
        
        let smiley = SKSpriteNode(imageNamed: "smile")
        smiley.zPosition = 3
        smiley.size = CGSize(width: 20, height: 20)
        smiley.position = CGPoint(x: size.width * 0.02, y: size.height * 0.83)
        addChild(smiley)
        
        happinessBar = CustomBar(color: .blue, size: CGSize(width: health, height: 15))
        happinessBar.position = CGPoint(x: size.width * 0.05, y: size.height * 0.83)
        happinessBar.zPosition = 3
        addChild(happinessBar)
        
        happinessLabel = SKLabelNode(fontNamed: "Chalkduster")
        happinessLabel!.text = "Happiness : 100%"
        happinessLabel!.fontSize = 20
        happinessLabel!.zPosition = 2
        happinessLabel!.position = CGPoint(x: size.width * 0.13, y: size.height * 0.8)

        shieldLabel = SKLabelNode(fontNamed: "Chalkduster")
        shieldLabel!.text = ""
        shieldLabel!.fontColor = UIColor.green
        shieldLabel!.fontSize = 25
        shieldLabel!.zPosition = 2
        shieldLabel!.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        addChild(shieldLabel!)
        
        let toothBrushIcon = SKSpriteNode(imageNamed: icon)
        toothBrushIcon.zPosition = 2
        toothBrushIcon.size = CGSize(width: 30, height: 30)
        
        let circle = SKShapeNode(circleOfRadius: 25)
        circle.zPosition = 2
        circle.strokeColor = UIColor.white
        circle.position = CGPoint(x: size.width * 0.95, y: size.height * 0.1)
        circle.addChild(toothBrushIcon)
        
        addChild(circle)

    }


    /* ----------------------- BLADE RELATED METHODS ------------------------ */

    // This will help you to initialize our blade
    func presentBladeAtPosition(_ position:CGPoint) {
        blade = SwipeNode(position: position, target: self, color: .white)

        guard let blade = blade else {
            fatalError("Blade could not be created")
        }
        blade.enablePhysics(categoryBitMask: PhysicsCategory.Player, contactTestBitmask: PhysicsCategory.External,
                collisionBitmask: PhysicsCategory.None)

        addChild(blade)
    }

    // This will help you to remove the blade and reset the delta value
    func removeBlade() {
        guard let blade = blade else {
            return
        }

        blade.removeFromParent()
        delta = .zero
    }

    // MARK: - Touch Events

    // initialize the blade at touch location
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        presentBladeAtPosition(touchLocation)
    }

    // delta value will help you later to properly update the blade position,
    // Calculate the difference between currentPoint and previousPosition and store that value in delta
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let currentPoint = touch.location(in: self)
        let previousPoint = touch.previousLocation(in: self)
        delta = CGPoint(x: currentPoint.x - previousPoint.x, y: currentPoint.y - previousPoint.y)
    }

    // Remove the Blade if the touches have been cancelled or ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeBlade()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeBlade()
    }

    // MARK: - FPS

    override func update(_ currentTime: TimeInterval) {
        if (health <= 0) {
            levelEnd(won: false)
        }
        if (levelPhysics.hasSticky > 0) {
            levelPhysics.stickyEffect()
        }
        // if the blade is not available return
        guard let blade = blade else {
            return
        }

        // Here you add the delta value to the blade position
        let newPosition = CGPoint(x: blade.position.x + delta.x, y: blade.position.y + delta.y)
        // Set the new position
        blade.position = newPosition
        // it's important to reset delta at this point,
        // You are telling the blade to only update his position when touchesMoved is called
        delta = .zero


    }

    func influx() {
        levelExecution.influx()
    }
}
