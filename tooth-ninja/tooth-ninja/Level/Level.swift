//
//  Level.swift includes all classes and protocols related to level
//  initialisation and running.
//
//  Created by David Lopez on 9/6/18.
//  Copyright © 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit

/* BaseLevel protocol includes the required fields and functions for a level */
protocol BaseLevel {
    var controller: Controller? {get}
    var scoreLabel: SKLabelNode? {get}
    var healthLabel: SKLabelNode? {get}
    var backgroundFile: String? {get}
    var teethArray: [GameObject] {get set}   // array of teeth in a level
    var otherArray: [GameObject] {get set}   // array of possible objects in a level
    var levelExecution: LevelExecution! {get}
    var levelPhysics: LevelPhysics! {get}
}

protocol LevelController {
    var score: Int {get set}
    var health: Int {get set}
}

/* This extension provides functionality to make callbacks to the Controller */
extension BaseLevel {

    func levelCompleted() {
        controller?.levelCompleted()
    }
    
    func LevelFailed() {
        controller?.levelFailed()
    }
    
}

/* Level class is in charge of initialising, running the level and notifying the
 * controller of level completion or failure.
 */
class Level: SKScene, SKPhysicsContactDelegate, BaseLevel, LevelController {

    var controller: Controller?
    var scoreLabel: SKLabelNode?
    var healthLabel: SKLabelNode?
    var teethArray: [GameObject]
    var otherArray: [GameObject]
    let backgroundFile: String?
    var levelExecution: LevelExecution!
    var levelPhysics: LevelPhysics!

    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }

    var health = 100 {
        didSet {
            if health > 100 {
                health = 100
            }
            healthLabel?.text = "HP: \(health)%"
        }
    }

    // This optional variable will help you to easily access the blade
    var blade: SwipeNode?

    // This will help you to update the position of the blade
    // Set the initial value to 0
    var delta: CGPoint = .zero

    init(size: CGSize, bgFile: String, teethArray: [GameObject], otherArray: [GameObject], c: Controller) {
        self.teethArray = teethArray
        self.controller = c
        self.backgroundFile = bgFile
        self.otherArray = otherArray
        super.init(size: size)
        // use the JSON thing to give the level the game elements
    }

    required public init?(coder aDecoder: NSCoder) {
        teethArray = []
        backgroundFile = nil
        otherArray = []
        super.init(coder: aDecoder)
    }

    public override func didMove(to view: SKView) {
        levelExecution = LevelExecution(level: self, array: otherArray)
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

    /* Sets the background of the level and initialises the health and score bars */
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
        scoreLabel!.fontSize = 25
        scoreLabel!.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        addChild(scoreLabel!)

        healthLabel = SKLabelNode(fontNamed: "Chalkduster")
        healthLabel!.text = "HP: 100%"
        healthLabel!.fontSize = 25
        healthLabel!.zPosition = 2
        healthLabel!.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        addChild(healthLabel!)

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
}
