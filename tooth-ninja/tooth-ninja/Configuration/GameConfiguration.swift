//
// Created by David Lopez on 10/6/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation
import SpriteKit

/* Functions and statements to set and query UserDefaults */

let defaults = UserDefaults.standard

enum DefaultTypes: String {
    case BacteriaSize
    case Speed
}

func setDefaults(type: DefaultTypes, value: Double) {
    defaults.set(value, forKey: type.rawValue)
}

func queryDefaults(type: DefaultTypes) -> Double {
    return defaults.double(forKey: type.rawValue)
}

/* Decodable struct to be able to use JSONDecoder to parse */
struct GameConfigurationDecodable: Decodable {
    var speed: Double
    var size: Double
    var levels: [LevelConfig]

   struct LevelConfig: Decodable {
       var id: Int
       var teeth: [GameObjectConfig]
       var bacteria: [GameObjectConfig]
       var food: [GameObjectConfig]

       struct GameObjectConfig: Decodable {
           var name: String
           var kind: String?
           var position_x: Double?
           var position_y: Double?
           var rotation: Double?
           var position_z: Int
           var size_width: Double
           var size_height: Double
           var image: String
       }
   }
}

/* GameConfiguration class reads the JSON file with the level specs */
class GameConfiguration {
    static var screenSize: CGSize?

    let parsed: GameConfigurationDecodable

    init(file: String, size: CGSize) throws {
        GameConfiguration.screenSize = size
        let data = try GameConfiguration.readJSON(fileName: file)
        let decoder = JSONDecoder()
        parsed = try decoder.decode(GameConfigurationDecodable.self, from: data!)
    }

    static func readJSON (fileName: String) throws -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
        }
        return nil
    }

    /* Shameful redundancy happening below */
    /* TODO (2): Abstract these functions */

    func getTeethByLevel(id: Int) -> [GameObject] {
        var array: [GameObject] = []
        for tooth in parsed.levels[id - 1].teeth {
            array.append(GameObject(type: GameObjectType.Tooth, properties: tooth))
        }
        return array
    }

    func getObjectsByLevel(id: Int) -> [GameObject] {
        var array: [GameObject] = []
        for bacteria in parsed.levels[id - 1].bacteria {
            print(bacteria)
            array.append(GameObject(type: GameObjectType.Other, properties: bacteria))
        }
        for food in parsed.levels[id - 1].food {
            print(food)
            array.append(GameObject(type: GameObjectType.Other, properties: food))
        }
        return array
    }
}
