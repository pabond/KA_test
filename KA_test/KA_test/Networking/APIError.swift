//
//  APIError.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//


struct APIError: Codable, Error {
    
    var code: Int = 0
    let message: String
    
    let details: [String]
    let detailsMap: [String: [String]]
    
    private enum ErrorKeys: String, CodingKey {
        case message
        case details
    }
    
    init(code: Int) {
        self.code = code
        self.message = "unknown"
        self.details = []
        self.detailsMap = [:]
    }
    
    static func unknown(_ code: Int? = nil) -> Self {
        return APIError(code: code ?? 9999)
    }
}

enum GeneralError: Error {
    case generic
    case notFound
}
