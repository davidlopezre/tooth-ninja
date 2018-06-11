//
// Created by David Lopez on 10/6/18.
// Copyright (c) 2018 David Lopez. All rights reserved.
//

import Foundation

enum JSONParsingError: Error {
    case invalidFile
}

/* JSONLevelParser class provides methods to parse JSON files and creating a GameElementFactory for */
class JSONLevelParser {

    let jsonDict: Dictionary<String, AnyObject>

    init(fileName: String) throws {
        jsonDict = try JSONLevelParser.readJSON(fileName: fileName)!

    }

    static func readJSON (fileName: String) throws -> Dictionary<String, AnyObject>? {

        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {

                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    return jsonResult
                }
        }
        return nil
    }

    func getTeeth() -> [GameObject] {

        return []
    }

    func getProperty() {
        if let str = jsonDict["level"] as? Int {
            print(str)
        }
    }

    func getArrayDict() {
        // TODO (1) Transform JSON array object into array of dict
    }

}
