//
// Created by David Lopez and Kushagra Vashisht on 20/6/18.
// Copyright (c) 2018 David Lopez and Kushagra Vashisht. All rights reserved.
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
    private let NOCHANGE = "nochange"

    /* Numeric Constants */
    private let PLUS_HEALTH     =  25
    private let MINUS_HEALTH    =  10
    private let PLUS_HAPPINESS  =  10
    private let MINUS_HAPPINESS =  10
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

        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            externalBody = contact.bodyB
        } else {
            playerBody = contact.bodyB
            externalBody = contact.bodyA
        }

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
        }
    }

    func swipeCollidesWithBacteria(bacteria: GameObject) {
        if (bacteria.kind == STICKY){
            hasSticky -= 1
        }
        bacteria.removeFromParent()
        level.score += PLUS_SCORE
        if (level.score >= WINNING_SCORE) {
            level.levelEnd(won: true)
        }
    }

//  MADE A NEW FOOD_TYPE NOCHANGE FOR CHEESE AND MILK WHICH DOESN'T DECREASE THE HAPPINESS WHEN SWIPED
    func foodCollidesWithTooth(food: GameObject)
    {
        food.removeFromParent()
        if (food.kind == GOOD)
        {
            level.health += PLUS_HEALTH
            level.happiness -= MINUS_HAPPINESS
        }
        else if (food.kind == NOCHANGE)
        {
            level.health += PLUS_HEALTH
        }
        else if (food.kind == BAD)
        {
            level.happiness += PLUS_HAPPINESS
            level.levelExecution.influx()
        }
        else if (food.kind == SHIELD)
        {
            giveShield()
        }
    }

    func swipeCollidesWithFood(food: GameObject) {
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
    
//    NEEDS FIXING HERE
    func spawnObjects (influx: Bool) {
        let proba = random(min: 0, max: 100)    // probability, if > 90 it's food else bacteria
        let probb = random(min: 0, max: 50)
        
        var objectToAdd : GameObject? = nil
        var objectToAdd2: GameObject? = nil
        
//        TRYING TO PLAY AROUND WITH THE PROB NUMBER TO EVEN OUT THE NUMBER OF BACTERIA'S AND FOOD THAT APPEAR
        if (proba < 50) || influx {
            let index = randomIndex(bacteriaArray.count)
            objectToAdd = bacteriaArray[index].copy() as? GameObject
            objectToAdd?.position = generateRandomPosition(width: level.size.width, height: level.size.height)
            print("Level Width: " , level.size.width)
            print("Level Height: " , level.size.height)
            
            level.addChild(objectToAdd!)
        } else if (foodArray.count > 0){
            let index = randomIndex(foodArray.count)
            objectToAdd = foodArray[index].copy() as? GameObject
            objectToAdd?.position = generateRandomPosition(width: level.size.width, height: level.size.height)
            level.addChild(objectToAdd!)
        }
//        TRYING TO REPLICATE THE PREVIOUS PARAGRAPH TO GET TWO STREAMS OF SPAWNS INSTEAD OF ONE WHICH WILL(HOPEFULLY) SOLVE THE SPAWN ISSUE
        if (probb < 25) || influx {
            let index2 = randomIndex(bacteriaArray.count)
            objectToAdd2 = bacteriaArray[index2].copy() as? GameObject
            objectToAdd2?.position = generateRandomPosition(width: level.size.width, height: level.size.height)
            level.addChild(objectToAdd2!)
        } else if (foodArray.count > 0){
            let index2 = randomIndex(foodArray.count)
            objectToAdd2 = foodArray[index2].copy() as? GameObject
            objectToAdd2?.position = generateRandomPosition(width: level.size.width, height: level.size.height)
            level.addChild(objectToAdd2!)
        }
        
        
        // Determine speed of the object
        var actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        if (defaultSpeed > 0) {
            actualDuration *= CGFloat(defaultSpeed)
        }

        // Create the actions
        let teeth = level["tooth"]

        let targetToothIndex = random(min: 0, max: CGFloat(teeth.count))
        let targetTooth = teeth[Int(targetToothIndex)]

        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))

        objectToAdd?.run(actionMove)
        objectToAdd2?.run(actionMove)

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
        let original = level.alpha
        level.run(SKAction.sequence(
                [SKAction.fadeAlpha(to: 0, duration: 0.2),
                 SKAction.fadeAlpha(to: original, duration: 0.2)
                ]))
    }
}
