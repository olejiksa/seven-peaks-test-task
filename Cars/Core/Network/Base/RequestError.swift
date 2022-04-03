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
    case notFound
    case badRequest
    case outdated
    case unknown
}

extension RequestError {

    init?(statusCode: Int) {
        switch statusCode {
        case 200...299:
            return nil
        case 404:
            self = .notFound
        case 401...500:
            self = .unauthorized
        case 400, 501...599:
            self = .badRequest
        case 600:
            self = .outdated
        default:
            self = .unexpectedStatusCode
        }
    }
}

// MARK: - CustomStringConvertible

extension RequestError: CustomStringConvertible {

    var description: String {
        switch self {
        case .decode:
            return "We could not decode the response"
        case .invalidURL:
            return "The URL you requested is invalid"
        case .noResponse:
            return "Response returned with no data to decode"
        case .unauthorized:
            return "You need to be authenticated first"
        case .noInternet:
            return "Unable to connect to the Internet"
        case .notFound:
            return "Not Found"
        case .badRequest:
            return "Bad request"
        case .outdated:
            return "The URL you requested is outdated"
        default:
            return "Unknown error"
        }
    }
}
