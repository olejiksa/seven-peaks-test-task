//
//  JSONParser.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import Foundation

struct JSONParser {

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateDecodingStrategy = DateDecodingStrategy()
        decoder.dateDecodingStrategy = .custom(dateDecodingStrategy.convert)
        return decoder
    }()

    func decode<T: Decodable>(data: Data, responseModel: T.Type) throws -> T {
        try decoder.decode(responseModel, from: data)
    }
}
