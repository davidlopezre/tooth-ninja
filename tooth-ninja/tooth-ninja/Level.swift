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
private protocol BaseLevel {
    var controller: Controller? {get}
    var scoreLabel: SKLabelNode? {get set}
    var healthLabel: SKLabelNode? {get set}
    var backgroundFile: String? {get}
    var score: Int {get set}
    var health: Int {get set}
    var levelElements: [GameElement] {get set}   // array of possible objects in a level
    func runLevel(levelElements: [GameElement])
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
public class Level: SKScene, SKPhysicsContactDelegate, BaseLevel {

    fileprivate var controller: Controller?
    fileprivate var scoreLabel: SKLabelNode?
    fileprivate var healthLabel: SKLabelNode?
    fileprivate var score = 0
    fileprivate var health = 100
    fileprivate var levelElements: [GameElement]
    fileprivate let backgroundFile: String?

//    // This optional variable will help you to easily access the blade
//    var blade: SwipeNode?
//
//    // This will help you to update the position of the blade
//    // Set the initial value to 0
//    var delta: CGPoint = .zero

    init(size: CGSize, bgFile: String, lvlElements: [GameElement], c: Controller) {
        self.levelElements = lvlElements
        self.controller = c
        self.backgroundFile = bgFile
        super.init(size: size)
        // use the JSON thing to give the level the game elements
    }

    required public init?(coder aDecoder: NSCoder) {
        levelElements = []
        backgroundFile = nil
        super.init(coder: aDecoder)
    }

    public override func didMove(to view: SKView) {
        addBackground()
    }

    func addBackground() {
        if let bgFile = backgroundFile {
            let background = SKSpriteNode(imageNamed: bgFile)
            background.zPosition = 1
            background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
//            print("background, scene size is \(self.size.width) and \(self.size.height)")
            background.size = size
            addChild(background)
        }
    }

    /* Sequences the events in the level */
    func runLevel(levelElements: [GameElement]){

    }

    public func didBegin(_ contact: SKPhysicsContact) {

    }

    /* ----------------------- BLADE RELATED METHODS ------------------------ */

//    // This will help you to initialize our blade
//    func presentBladeAtPosition(_ position:CGPoint) {
//        blade = SwipeNode(position: position, target: self, color: .white)
//
//        guard let blade = blade else {
//            fatalError("Blade could not be created")
//        }
//        blade.enablePhysics(categoryBitMask: PhysicsCategory.Player, contactTestBitmask: PhysicsCategory.External,
//                collisionBitmask: PhysicsCategory.None)
//
//        addChild(blade)
//    }
//
//    // This will help you to remove the blade and reset the delta value
//    func removeBlade() {
//        guard let blade = blade else {
//            return
//        }
//
//        blade.removeFromParent()
//        delta = .zero
//    }
//
//    // MARK: - Touch Events
//
//    // initialize the blade at touch location
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let touchLocation = touch.location(in: self)
//        presentBladeAtPosition(touchLocation)
//    }
//
//    // delta value will help you later to properly update the blade position,
//    // Calculate the difference between currentPoint and previousPosition and store that value in delta
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let currentPoint = touch.location(in: self)
//        let previousPoint = touch.previousLocation(in: self)
//        delta = CGPoint(x: currentPoint.x - previousPoint.x, y: currentPoint.y - previousPoint.y)
//    }
//
//    // Remove the Blade if the touches have been cancelled or ended
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeBlade()
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeBlade()
//    }
//
//    // MARK: - FPS
//
//    override func update(_ currentTime: TimeInterval) {
//        // if the blade is not available return
//        guard let blade = blade else {
//            return
//        }
//
//        // Here you add the delta value to the blade position
//        let newPosition = CGPoint(x: blade.position.x + delta.x, y: blade.position.y + delta.y)
//        // Set the new position
//        blade.position = newPosition
//        // it's important to reset delta at this point,
//        // You are telling the blade to only update his position when touchesMoved is called
//        delta = .zero
//    }

}
