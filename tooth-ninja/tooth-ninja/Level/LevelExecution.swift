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

    init(level: Level) {
        self.level = level
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody: SKPhysicsBody
        var externalBody: SKPhysicsBody

        print("body a bitmask: \(contact.bodyA.categoryBitMask)")
        print("body b bitmask: \(contact.bodyB.categoryBitMask)")
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            externalBody = contact.bodyB
        } else {
            playerBody = contact.bodyB
            externalBody = contact.bodyA
        }
        print("player body is set to: \(playerBody.categoryBitMask)")
        print("external body is set to: \(externalBody.categoryBitMask)")

        if playerBody.node?.name == "swipe" {
            if externalBody.node?.name == "bacteria" || externalBody.node?.name == "sticky_bacteria" || externalBody.node?.name == "good_bacteria" {
                if let bacteria = externalBody.node as? SKSpriteNode {
                    swipeCollidesWithBacteria(bacteria: bacteria)
                }
            }
//            }else if externalBody.node?.name == "goodfood" {
//                if let goodFood = externalBody.node as? SKSpriteNode {
//                    swipeCollidesWithGoodFood(goodFood: goodFood)
//                }
//            }else if externalBody.node?.name == "badfood" {
//                if let badFood = externalBody.node as? SKSpriteNode {
//                    swipeCollidesWithBadFood(badFood: badFood)
//                }
//            }
        }else {
            if externalBody.node?.name == "bacteria" || externalBody.node?.name == "bacteria2" {
                if let bacteria = externalBody.node as? SKSpriteNode {
                    bacteriaCollidesWithTooth(bacteria: bacteria)
                }
            }
        }
    }

    func bacteriaCollidesWithTooth(bacteria: SKSpriteNode) {
        print("Collision: Bacteria-Tooth")
        bacteria.removeFromParent()
        level.health -= 90
        if (level.health <= 0) {
//          level.levelCompleted()
        }
    }

//    func goodBacteriaCollidesWithTooth(bacteria: SKSpriteNode) {
//        print("Collision: GoodBacteria-Tooth")
//        bacteria.removeFromParent()
//        shield = 10
//    }
//
//
    func swipeCollidesWithBacteria(bacteria: SKSpriteNode) {
        print("Collision: Swipe-Bacteria")
        bacteria.removeFromParent()
        level.score += 1
    }
//
//    func goodFoodCollidesWithTooth(goodFood: SKSpriteNode) {
//        print("Collision: GoodFood-Tooth")
//        goodFood.removeFromParent()
//        health += 10
//    }
//
//    func badFoodCollidesWithTooth(badFood: SKSpriteNode) {
//        print("Collision: BadFood-Tooth")
//        badFood.removeFromParent()
//        let s1 = SKAction.run {
//            addBacteria(scene: self, completion: {
//                print("add bacteria")
//            })
//        }
//        let influx = SKAction.repeat(s1, count: 5)
//        let action = SKAction.sequence([
//            influx,
//            SKAction.wait(forDuration: 1),
//            influx,
//            SKAction.wait(forDuration: 1),
//            influx,
//            SKAction.wait(forDuration: 1)
//            ])
//        run(action)
//    }
//
//    func swipeCollidesWithGoodFood(goodFood: SKSpriteNode) {
//        print("Collision: Swipe-GoodFood")
//        goodFood.removeFromParent()
//    }
//
//    func swipeCollidesWithBadFood(badFood: SKSpriteNode) {
//        print("Collision: Swipe-BadFood")
//        badFood.removeFromParent()
//    }
//
//    func swipeCollidesWithGoodBacteria(bacteria: SKSpriteNode) {
//        print("Collision: Swipe-GoodBacteria")
//        bacteria.removeFromParent()
//    }
//


}

/* This class is in charge of executing actions that will be a result of game
 * object interaction. For example, creating a shield when good bacteria touches
 * tooth.
 */
class LevelExecution {
    let objectArray: [GameObject]
    var level: Level

    init(level: Level, array: [GameObject]) {
        self.level = level
        objectArray = array
    }

    /* This function is in charge of spawning food and bacteria and giving them the action to
     * approach the teeth in the level.
     */
    func spawnObjects () {
        let index = randomIndex(objectArray.count)
        let objectToAdd = objectArray[index].copy() as! GameObject
        level.addChild(objectToAdd)

        // TODO (3) Fix that every object's initial position is (0,0)
        print("initial position of \(objectToAdd.name ?? "no name") is \(objectToAdd.position)")
        // Determine speed of the object
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

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

}