//
// Created by David Lopez on 8/7/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation

let x = [NSMutableArray(), NSMutableArray(), NSMutableArray()]
let y = x
let z = x.map { $0.copy() }

func copyArray (array: [AnyObject]) -> [AnyObject]{
    let returnArray = array.map { $0.copy() }
    return (returnArray as? [AnyObject])!
}