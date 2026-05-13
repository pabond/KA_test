//
//  AnyPublisher.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//


import Foundation
import Combine

extension AnyPublisher {
    static func just(_ value: Output) -> Self {
        Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
    
    static func fail(_ error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }
    
    static func empty(completeImmediately: Bool = true) -> Self {
        Empty(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }
}
