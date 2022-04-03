//
//  HTTPClient.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

import Foundation

protocol HTTPClient: Connection {

    @available(iOS 15, *)
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type) async -> Result<T, RequestError>

    @available(iOS, deprecated: 15)
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping (Result<T, RequestError>) -> Void)
}

extension HTTPClient {

    @available(iOS 15, *)
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type) async -> Result<T, RequestError> {
        guard hasConnectivity else {
            return .failure(.noInternet)
        }

        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }

        let request = createRequest(url: url, endpoint: endpoint)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return check(data: data, response: response, responseModel: responseModel)
        } catch {
            return .failure(.unknown)
        }
    }

    @available(iOS, deprecated: 15)
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping (Result<T, RequestError>) -> Void) {
        guard hasConnectivity else {
            completion(.failure(.noInternet))
            return
        }

        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            completion(.failure(.invalidURL))
            return
        }

        let request = createRequest(url: url, endpoint: endpoint)
        let task = URLSession.shared.dataTask(with: request) {
            let result: Result<T, RequestError> = check(data: $0,
                                                        response: $1,
                                                        responseModel: responseModel,
                                                        error: $2)
            DispatchQueue.main.async {
                completion(result)
            }
        }

        task.resume()
    }
}

// MARK: - Private

private extension HTTPClient {

    func createRequest(url: URL, endpoint: Endpoint) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        return request
    }

    func check<T: Decodable>(data: Data?,
                             response: URLResponse?,
                             responseModel: T.Type,
                             error: Error? = nil) -> Result<T, RequestError> {
        guard let data = data, error == nil else {
            return .failure(.unknown)
        }

        guard let response = response as? HTTPURLResponse else {
            return .failure(.noResponse)
        }

        if let requestError = RequestError(statusCode: response.statusCode) {
            return .failure(requestError)
        } else {
            return decode(data: data, response: response, responseModel: responseModel)
        }
    }

    func decode<T: Decodable>(data: Data,
                              response: HTTPURLResponse,
                              responseModel: T.Type) -> Result<T, RequestError> {
        do {
            let decoder = JSONDecoder()
            let dateDecodingStrategy = DateDecodingStrategy()
            decoder.dateDecodingStrategy = .custom(dateDecodingStrategy.convert)
            let decodedResponse = try decoder.decode(responseModel, from: data)
            return .success(decodedResponse)
        } catch let error {
            print(error)
            return .failure(.decode)
        }
    }
}
