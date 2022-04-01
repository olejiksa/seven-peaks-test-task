//
//  ArticlesService.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

protocol ArticlesServiceable {

    @available(iOS 15, *)
    func getAll() async -> Result<Response<Article>, RequestError>

    @available(iOS, deprecated: 15)
    func getAll(completion: @escaping (Result<Response<Article>, RequestError>) -> Void)
}

struct ArticlesService: HTTPClient, ArticlesServiceable {

    @available(iOS 15, *)
    func getAll() async -> Result<Response<Article>, RequestError> {
        return await sendRequest(endpoint: ArticlesEndpoint.getAll,
                                 responseModel: Response<Article>.self)
    }

    @available(iOS, deprecated: 15)
    func getAll(completion: @escaping (Result<Response<Article>, RequestError>) -> Void) {
        return sendRequest(endpoint: ArticlesEndpoint.getAll,
                           responseModel: Response<Article>.self,
                           completion: completion)
    }
}
