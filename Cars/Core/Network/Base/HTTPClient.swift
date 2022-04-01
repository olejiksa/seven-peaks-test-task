//
//  HTTPClient.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

import Foundation

protocol HTTPClient {

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
                                   completion: @escaping (Result<T, RequestError>) -> ()) {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            completion(.failure(.invalidURL))
            return
        }

        let request = createRequest(url: url, endpoint: endpoint)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let result: Result<T, RequestError> = check(data: data,
                                                        response: response,
                                                        responseModel: responseModel,
                                                        error: error)
            completion(result)
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

        switch response.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom(convert)
                let decodedResponse = try decoder.decode(responseModel, from: data)
                return .success(decodedResponse)
            } catch let error {
                print(error)
                return .failure(.decode)
            }
        case 401:
            return .failure(.unauthorized)
        default:
            return .failure(.unexpectedStatusCode)
        }
    }

    func convert(using decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let date: Date?

        if let string = try? container.decode(String.self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YYYY HH:mm"
            date = formatter.date(from: string)
        } else if let number = try? container.decode(Double.self) {
            date = Date(timeIntervalSince1970: number)
        } else {
            date = nil
        }

        if let date = date {
            return date
        } else {
            throw RequestError.decode
        }
    }
}
