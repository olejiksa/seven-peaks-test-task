//
//  RequestError.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

enum RequestError: Error {

    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case noInternet
    case unknown
}

// MARK: - CustomStringConvertible

extension RequestError: CustomStringConvertible {

    var description: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .noInternet:
            return "No Internet"
        default:
            return "Unknown error"
        }
    }
}
