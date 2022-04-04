//
//  ArticlesServiceSpy.swift
//  CarsTests
//
//  Created by Oleg Samoylov on 04.04.2022.
//

@testable import Cars

final class ArticlesServiceSpy: ArticlesServiceable {

    private(set) var getAllCalled = false

    func getAll() async -> Result<[Article], RequestError> {
        getAllCalled = true
        return .success([])
    }

    func getAll(completion: @escaping (Result<[Article], RequestError>) -> Void) {
        getAllCalled = true
        completion(.success([]))
    }
}
