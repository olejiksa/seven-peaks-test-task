//
//  Response.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

struct Response<T: Decodable>: Decodable {

    private enum CodingKeys: String, CodingKey {
        case status
        case items = "content"
    }

    let status: String
    let items: [T]
}
