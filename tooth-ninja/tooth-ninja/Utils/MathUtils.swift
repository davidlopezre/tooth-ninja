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