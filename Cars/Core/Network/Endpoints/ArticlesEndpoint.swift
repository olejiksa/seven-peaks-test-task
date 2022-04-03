//
//  ArticlesEndpoint.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

enum ArticlesEndpoint {
    case getAll
}

// MARK: - Endpoint

extension ArticlesEndpoint: Endpoint {

    var path: String {
        switch self {
        case .getAll:
            return "article/get_articles_list"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getAll:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .getAll:
            return nil
        }
    }

    var body: [String: String]? {
        switch self {
        case .getAll:
            return nil
        }
    }
}
