//
// Created by David Lopez on 11/6/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit

/* This file contains some random utility functions */

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

/* Used to get a random index from an array */
func randomIndex(_ count: Int) -> Int {
    return Int(arc4random_uniform(UInt32(count)))
}

func generateRandomPosition(width: CGFloat, height: CGFloat) -> CGPoint {
    var possibilities: [CGPoint] = []
    var helperWidth = [0, width]
    var helperHeight = [0, height]

    var pos1: CGPoint = CGPoint()
    pos1.y = random(min: 0, max: height)
    pos1.x = helperWidth[randomIndex(2)]
    possibilities.append(pos1)

    var pos2: CGPoint = CGPoint()
    pos1.x = random(min: 0, max: width)
    pos1.y = helperHeight[randomIndex(2)]
    possibilities.append(pos2)

    return possibilities[randomIndex(2)]
}
