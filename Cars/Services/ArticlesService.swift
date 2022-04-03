//
//  ArticlesService.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

protocol ArticlesServiceable {

    @available(iOS 15, *)
    func getAll() async -> Result<[Article], RequestError>

    @available(iOS, deprecated: 15)
    func getAll(completion: @escaping (Result<[Article], RequestError>) -> Void)
}

struct ArticlesService {

    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }
}

// MARK: - Private

private extension ArticlesService {

    func process(articles: [Article]?, error: RequestError) -> Result<[Article], RequestError> {
        if let articles = articles, !articles.isEmpty {
            return .success(articles)
        } else {
            return .failure(error)
        }
    }
}

// MARK: - ArticlesServiceable, HTTPClient

extension ArticlesService: ArticlesServiceable, HTTPClient {

    @available(iOS 15, *)
    func getAll() async -> Result<[Article], RequestError> {
        let result = await sendRequest(endpoint: ArticlesEndpoint.getAll,
                                       responseModel: Response<Article>.self)
        switch result {
        case .success(let response):
            storage.save(items: response.items)
            return .success(response.items)
        case .failure(let error):
            let articles = await storage.fetch()
            return process(articles: articles, error: error)
        }
    }

    @available(iOS, deprecated: 15)
    func getAll(completion: @escaping (Result<[Article], RequestError>) -> Void) {
        sendRequest(endpoint: ArticlesEndpoint.getAll,
                    responseModel: Response<Article>.self) { [weak storage] in
            switch $0 {
            case .success(let response):
                storage?.save(items: response.items)
                completion(.success(response.items))
            case .failure(let error):
                storage?.fetch { articles in
                    let result = process(articles: articles, error: error)
                    completion(result)
                }
            }
        }
    }
}
