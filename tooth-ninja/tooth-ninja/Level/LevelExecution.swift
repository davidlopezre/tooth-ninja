//
// Created by David Lopez on 20/6/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit

class LevelPhysics {

}

class LevelExecution {
    let objectArray: [GameObject]
    var level: Level

    init(level: Level, array: [GameObject]) {
        self.level = level
        objectArray = array
    }

    func runLevel() {
        // abstract this crap
        let randomIndex = Int(arc4random_uniform(UInt32(objectArray.count)))
        let objectToAdd = objectArray[randomIndex].copy() as! GameObject
        level.addChild(objectToAdd)

        // Determine speed of the food
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        // Create the actions
        let teeth = level["tooth"]
        print("There are \(teeth.count) teeth")

        let targetToothIndex = random(min: 0, max: CGFloat(teeth.count))
        let targetTooth = teeth[Int(targetToothIndex)]

        let actionMove = SKAction.move(to: targetTooth.position, duration: TimeInterval(actualDuration))

        objectToAdd.run(actionMove)

    }

}