//
// Created by David Lopez on 20/6/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit

/* This class is in charge of managing game object physics. For example,
 * what happens if bacteria touches tooth.
 */

class LevelPhysics {
    var level: Level
    var hasShield = false
    var hasSticky: Int = 0

    /* String Constants */
    private let BACTERIA = "bacteria"
    private let FOOD     = "food"
    private let SWIPE    = "swipe"
    private let GOOD     = "good"
    private let BAD      = "bad"
    private let STICKY   = "sticky"
    private let NORMAL   = "normal"
    private let SHIELD   = "shield"
    private let NEUTRAL  = "neutral"

    /* Numeric Constants */
    private let PLUS_HEALTH     =  25
    private let MINUS_HEALTH    =  10
    private let PLUS_HAPPINESS  =  10
    private let MINUS_HAPPINESS =  25
    private let PLUS_SCORE      =  10
    private var WINNING_SCORE : Int
    
    init(level: Level) {
        self.level = level
        WINNING_SCORE = level.winningScore
    }

    func didBegin(_ contact: SKPhysicsContact)
    {
        var playerBody: SKPhysicsBody
        var externalBody: SKPhysicsBody

//        print("body a bitmask: \(contact.bodyA.categoryBitMask)")
//        print("body b bitmask: \(contact.bodyB.categoryBitMask)")
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            externalBody = contact.bodyB
        } else {
            playerBody = contact.bodyB
            externalBody = contact.bodyA
        }
//        print("player body is set to: \(playerBody.categoryBitMask)")
//        print("external body is set to: \(externalBody.categoryBitMask)")

        if playerBody.node?.name == SWIPE {
            if externalBody.node?.name == BACTERIA {
                if let bacteria = externalBody.node as? GameObject {
                    swipeCollidesWithBacteria(bacteria: bacteria)
                }
            }else if externalBody.node?.name == FOOD {
                if let food = externalBody.node as? GameObject {
                    swipeCollidesWithFood(food: food)
                }
            }
        }else {
            if externalBody.node?.name == BACTERIA {
                if let bacteria = externalBody.node as? GameObject {
                    bacteriaCollidesWithTooth(bacteria: bacteria)
                }
            } else if externalBody.node?.name == FOOD {
                if let food = externalBody.node as? GameObject {
                    foodCollidesWithTooth(food: food)
                }
            }
        }
    }

    func bacteriaCollidesWithTooth(bacteria: GameObject) {
//        print("Collision: Bacteria-Tooth")
//        level.levelExecution.takeHitAnimation()
        if (hasShield) {
            removeShield()
            bacteria.removeFromParent()
            return
        }
        if (bacteria.kind == STICKY) {
            hasSticky += 1
            return
        } else {
            bacteria.removeFromParent()
            level.health -= MINUS_HEALTH
        }

        if (level.health <= 0) {
            level.levelEnd(won: false)
//            level.controller?.healthBar.isHidden = true
//            level.controller?.happinessBar.isHidden = true
        }
    }

    func swipeCollidesWithBacteria(bacteria: GameObject) {
        if (bacteria.kind == STICKY){
            hasSticky -= 1
        }
//        print("Collision: Swipe-Bacteria")
        bacteria.removeFromParent()
        level.score += PLUS_SCORE
        if (level.score >= WINNING_SCORE) {
            level.levelEnd(won: true)
        }
    }


    func foodCollidesWithTooth(food: GameObject) {
//        print("Collision: GoodFood-Tooth")
        food.removeFromParent()
        if (food.kind == GOOD) {
            level.health += PLUS_HEALTH
            level.happiness -= MINUS_HAPPINESS
        }else if (food.kind == BAD) {
            level.happiness += PLUS_HAPPINESS
            level.levelExecution.influx()
        } else if (food.kind == SHIELD) {
            giveShield()
        }
    }

    func swipeCollidesWithFood(food: GameObject) {
//        print("Collision: Swipe-Food")
        food.removeFromParent()

    }

    func stickyEffect() {
        level.health -= hasSticky
    }

    private func giveShield() {
        if (!hasShield) {
            hasShield = true
            level.shieldLabel?.text = "Shield"

            for teeth in level["tooth"] {
                let t = (teeth as! SKSpriteNode)
                let radius = max(t.size.width / 2, t.size.height / 2) * 1.5
                let shield = SKShapeNode(circleOfRadius: radius)
                shield.alpha = 0.08
                shield.fillColor = UIColor.white
                shield.zPosition = 4
                teeth.addChild(shield)

            }
        }
    }

    private func removeShield() {
        hasShield = false
        level.shieldLabel?.text = ""
        for teeth in level["tooth"] {
            teeth.removeAllChildren()
        }
    }

}

/* This class is in charge of executing actions that will be a result of game
 * object interaction. For example, creating a shield when good bacteria touches
 * tooth.
 */
class LevelExecution {
    let bacteriaArray: [GameObject]
    let foodArray: [GameObject]
    var level: Level
    var bacteria: [GameObject] = []

    private var defaultSpeed = queryDefaults(type: DefaultTypes.Speed)
    private var defaultSize = 1.0

    init(level: Level, bacteria: [GameObject], food: [GameObject]) {
        self.level = level
        bacteriaArray = bacteria
        foodArray = food

        defaultSpeed += queryDefaults(type: DefaultTypes.Speed)
        defaultSize += queryDefaults(type: DefaultTypes.BacteriaSize)
    }

    /* This function is in charge of spawning food and bacteria and giving them the action to
     * approach the teeth in the level.
     */
    func spawnObjects (influx: Bool) {
        let proba = random(min: 0, max: 100)    // probability, if > 90 it's food else bacteria
//        print(proba)
        
        var objectToAdd : GameObject? = nil
        
        if (proba < 80) || influx {
            let index = randomIndex(bacteriaArray.count)
            objectToAdd = bacteriaArray[index].copy() as? GameObject
            objectToAdd?.position = generateRandomPosition(width: level.size.width, height: level.size.height)
            level.addChild(objectToAdd!)
        } else if (foodArray.count > 0){
            let index = randomIndex(foodArray.count)
            objectToAdd = foodArray[index].copy() as? GameObject
            objectToAdd?.position = generateRandomPosition(width: level.size.width, height: level.size.height)
            level.addChild(objectToAdd!)
        }
        
        // Determine speed of the object
        var actualDuration = random(min: CGFloat(1.0), max: CGFloat(4.0))
        if (defaultSpeed > 0) {
            actualDuration *= CGFloat(defaultSpeed)
        }

        // Create the actions
        let teeth = level["tooth"]
//        print("There are \(teeth.count) teeth")

        let targetToothIndex = random(min: 0, max: CGFloat(teeth.count))
        let targetTooth = teeth[Int(targetToothIndex)]

        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))

        objectToAdd?.run(actionMove)

    }

    func runLevel() {
        let s1 = SKAction.run {
            self.spawnObjects(influx: false)
        }
        level.run(SKAction.repeatForever(SKAction.sequence([
            s1, SKAction.wait(forDuration: 2.0)])))
    }

    func influx() {
        let s1 = SKAction.run {
            self.spawnObjects(influx: true)
        }
        let influx = SKAction.repeat(s1, count: 5)
        let action = SKAction.sequence([
            influx,
            SKAction.wait(forDuration: 2),
            influx,
            SKAction.wait(forDuration: 2),
            influx,
            SKAction.wait(forDuration: 2)
            ])
        level.run(action)
    }

    func takeHitAnimation() {
//        setDefaults(type: DefaultTypes.Sp, value: <#T##Double##Swift.Double#>)
        let original = level.alpha
        level.run(SKAction.sequence(
                [SKAction.fadeAlpha(to: 0, duration: 0.2),
                 SKAction.fadeAlpha(to: original, duration: 0.2)
                ]))
    }
}
