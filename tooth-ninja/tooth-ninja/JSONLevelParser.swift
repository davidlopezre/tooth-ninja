//
// Created by David Lopez on 10/6/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation

struct GameInfo: Decodable {
    var speed: Double
    var size: Double
    var levels: [LevelInfo]

   struct LevelInfo: Decodable {
       var id: Int
       var teeth: [GameObjectInfo]

       struct GameObjectInfo: Decodable {
           var name: String
           var position_x: Double
           var position_y: Double
           var size_width: Double
           var size_height: Double
           var image: String
       }
   }
}

/* JSONLevelParser class provides methods to parse JSON files and creating a GameElementFactory for */
class JSONLevelParser {

    let parsed: GameInfo

    init(file: String) throws {
        let data = try JSONLevelParser.readJSON(fileName: file)
        let decoder = JSONDecoder()
        parsed = try decoder.decode(GameInfo.self, from: data!)

        print(parsed.speed)
        print(parsed.size)
        for level in parsed.levels {
            for tooth in level.teeth {
                print(tooth.image)
            }
        }
    }

    static func readJSON (fileName: String) throws -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
        }
        return nil
    }

    func getTeeth() -> [GameObject] {

        return []
    }
}
