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

    /* Constants */

    let BACTERIA = "bacteria"
    let FOOD     = "food"
    let SWIPE    = "swipe"
    let GOOD     = "good"
    let BAD      = "bad"
    let STICKY   = "sticky"
    let NORMAL   = "normal"
    let SHIELD   = "shield"
    let NEUTRAL  = "neutral"

    init(level: Level) {
        self.level = level
    }

    func didBegin(_ contact: SKPhysicsContact) {
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
        print("Collision: Bacteria-Tooth")
        level.levelExecution.takeHit()
        if (hasShield) {
            hasShield = false
            level.shieldLabel?.text = ""
            bacteria.removeFromParent()
            return
        }

        if (bacteria.kind == STICKY) {
            hasSticky += 1
            return
        } else{
            bacteria.removeFromParent()
            if (bacteria.kind == GOOD ) {
                hasShield = true
                level.shieldLabel?.text = "Shield"
            }else {
                level.health -= 25
            }
        }

        if (level.health <= 0) {
            level.levelEnd(won: false)
        }
    }

    func swipeCollidesWithBacteria(bacteria: GameObject) {
        if (bacteria.kind == STICKY){
            hasSticky -= 1
        }
        print("Collision: Swipe-Bacteria")
        bacteria.removeFromParent()
        level.score += 25
        if (level.score >= 100) {
            level.levelEnd(won: true)
        }
    }
//
    func foodCollidesWithTooth(food: GameObject) {
        print("Collision: GoodFood-Tooth")
        food.removeFromParent()
        if (food.kind == GOOD) {
            level.health += 10
            level.happiness -= 25
        }else if (food.kind == BAD) {
            level.happiness += 25
        } else if (food.kind == SHIELD) {
            hasShield = true
            level.shieldLabel?.text = "Shield"
        }
    }
    func swipeCollidesWithFood(food: GameObject) {
        print("Collision: Swipe-Food")
        food.removeFromParent()
//        if (food.kind == BAD) {
//            let influx = SKAction.repeat(s1, count: 5)
//        let action = SKAction.sequence([
//            influx,
//            SKAction.wait(forDuration: 1),
//            influx,
//            SKAction.wait(forDuration: 1),
//            influx,
//            SKAction.wait(forDuration: 1)
//            ])
//        level.run(action)
//        }
    }

    func stickyEffect() {
        level.health -= hasSticky
    }
}

/* This class is in charge of executing actions that will be a result of game
 * object interaction. For example, creating a shield when good bacteria touches
 * tooth.
 */
class LevelExecution {
    let objectArray: [GameObject]
    var level: Level
    var bacteria: [GameObject] = []

    init(level: Level, array: [GameObject]) {
        self.level = level
        objectArray = array
    }

    /* This function is in charge of spawning food and bacteria and giving them the action to
     * approach the teeth in the level.
     */
    func spawnObjects () {
        let index = randomIndex(objectArray.count)
        print("SIZE OF LEVEL IS \(level.size)")
        let objectToAdd = objectArray[index].copy() as! GameObject
        objectToAdd.position = generateRandomPosition(width: level.size.width, height: level.size.height)
        level.addChild(objectToAdd)

        // TODO (3) Fix that every object's initial position is (0,0)
        print("initial position of \(objectToAdd.name ?? "no name") is \(objectToAdd.position)")
        // Determine speed of the object
        let actualDuration = random(min: CGFloat(1.0), max: CGFloat(3.0))

        // Create the actions
        let teeth = level["tooth"]
//        print("There are \(teeth.count) teeth")

        let targetToothIndex = random(min: 0, max: CGFloat(teeth.count))
        let targetTooth = teeth[Int(targetToothIndex)]

        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))

        objectToAdd.run(actionMove)

    }

    func runLevel() {
        level.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(spawnObjects),SKAction.wait(forDuration: 2.0)])))
    }

    func takeHit() {
        let original = level.alpha
        level.run(SKAction.sequence(
                [SKAction.fadeAlpha(to: 0, duration: 0.2),
                 SKAction.fadeAlpha(to: original, duration: 0.2)
                ]))
    }
}
