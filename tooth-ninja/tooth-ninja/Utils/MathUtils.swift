//
// Created by David Lopez and Kushagra Vashisht on 11/6/18.
// Copyright (c) 2018 David Lopez and Kushagra Vashisht. All rights reserved.
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

    let pos2: CGPoint = CGPoint()
    pos1.x = random(min: 0, max: width)
    pos1.y = helperHeight[randomIndex(2)]
    possibilities.append(pos2)

    return possibilities[randomIndex(2)]
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
    
