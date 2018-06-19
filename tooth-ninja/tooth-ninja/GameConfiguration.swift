//
// Created by David Lopez on 10/6/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation

/* Decodable struct to be able to use JSONDecoder to parse */
struct GameConfig: Decodable {
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
           var position_x: Double?
           var position_y: Double?
           var position_z: Int
           var size_width: Double
           var size_height: Double
           var image: String
       }
   }
}

/* JSONLevelParser class provides methods to parse JSON files and creating a GameElementFactory for */
class GameConfiguration {

    let parsed: GameConfig

    init(file: String) throws {
        let data = try GameConfiguration.readJSON(fileName: file)
        let decoder = JSONDecoder()
        parsed = try decoder.decode(GameConfig.self, from: data!)
    }

    static func readJSON (fileName: String) throws -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
        }
        return nil
    }

    func getTeethByLevel(id: Int) -> [GameObject] {
        var array: [GameObject] = []
        for tooth in parsed.levels[id - 1].teeth {
            array.append(GameObject(type: GameObjectType.Tooth, properties: tooth))
        }
        return array
    }
}
