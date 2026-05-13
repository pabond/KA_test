//
//  APIService.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//


import Foundation
import Combine
import UIKit

class APIService {
    private var basicURL: String {
        return "https://api.randomuser.me"
    }
    
    private var cancellables = Set<AnyCancellable>()
}

extension APIService {
    func fetchUsers(page: Int, size: Int, seed: String?, version: String?) -> AnyPublisher<Result<ArrayPaginationResponse<User>, Error>, Never> {
        return performRequest(for: .usersList(page: page, results: size, seed: seed, version: version), hostURL: basicURL)
            .mapObject(of: ArrayPaginationResponse<User>.self)
            .toResult()
    }
}

private extension APIService {
    private func performRequest(for route: APIRoute, hostURL: String) -> AnyPublisher<Data, Error> {
        guard let request = route.makeRequest(baseURLString: hostURL) else {
            return .fail(APIError.unknown())
        }
        
        return performRequest(request: request)
    }
    
    private func performRequest(request: URLRequest) -> AnyPublisher<Data, Error> {
        return dataTask(with: request)
            .map { result in
                return result
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    private func dataTask(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    switch (response as! HTTPURLResponse).statusCode {
                    case (400...500):
                        if var error = try? JSONDecoder().decode(APIError.self, from: data) {
                            error.code = (response as! HTTPURLResponse).statusCode
                            throw error
                        } else {
                            throw APIError(code: (response as! HTTPURLResponse).statusCode)
                        }
                    default:
                        throw APIError.unknown()
                    }
                }
                return data
            }.eraseToAnyPublisher()
    }
}
