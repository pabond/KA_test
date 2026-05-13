//
//  Publisher+Decoder.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//

import Combine
import Foundation

extension Publisher {
    func toResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map { Result.success($0) }
            .catch { Just(Result.failure($0))}
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Data, Failure == Error {
    func mapJSON() -> AnyPublisher<[String: Any], Error> {
        tryMap { data in
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any] ?? [:]
        }
        .eraseToAnyPublisher()
    }

    func mapObject<T: Decodable>(of type: T.Type) -> AnyPublisher<T, Error> {
        tryMap { data in
            try JSONDecoder().decode(T.self, from: data)
        }
        .eraseToAnyPublisher()
    }

    func mapObject<T: Decodable>(of type: T.Type, atKeyPath keyPath: String, decoder: JSONDecoder = JSONDecoder.init()) -> AnyPublisher<T, Error> {
        mapJSON().tryMap { json in
            guard let jsonObject = json[keyPath] else {
                throw GeneralError.notFound
            }
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
            return try decoder.decode(T.self, from: jsonData)
        }
        .eraseToAnyPublisher()
    }

    func mapObjects<T: Decodable>(of type: T.Type, atKeyPaths keyPaths: [String]) -> AnyPublisher<[T], Error> {
        mapJSON().tryMap { json -> [T] in
                let result = try keyPaths.compactMap { keyPath -> T? in
                    guard
                        let nestedJson = json[keyPath],
                        let jsonData = try? JSONSerialization.data(withJSONObject: nestedJson)
                    else {
                        return nil
                    }
                    return try JSONDecoder().decode(T.self, from: jsonData)
                }
                return result
            }
        .eraseToAnyPublisher()
    }
}
