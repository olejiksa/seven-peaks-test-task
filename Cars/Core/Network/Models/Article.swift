//
//  Article.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

import Foundation

struct Article: Decodable, Unique {

    struct Item: Decodable {

        enum `Type`: String, Decodable {
            case text
        }

        private enum CodingKeys: String, CodingKey {
            case type
            case title = "subject"
            case text = "description"
        }

        let type: `Type`?
        let title: String
        let text: String
    }

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case ingress
        case imageURL = "image"
        case publishDate = "dateTime"
        case tags
        case items = "content"
        case creationDate = "created"
        case lastModifiedDate = "changed"
    }

    let identifier: Int64
    let title: String
    let ingress: String
    let imageURL: URL?
    let publishDate: Date
    let tags: [String]
    let items: [Item]
    let creationDate: Date
    let lastModifiedDate: Date
}
