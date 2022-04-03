//
//  Endpoint.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

protocol Endpoint {

    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {

    var baseURL: String {
        "https://www.apphusetreach.no/application/119267/"
    }
}
