//
//  ArrayPaginationResponse.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//

struct ArrayPaginationResponse<T: Codable>: Codable {

    let results: [T]
    let info: Info
    
    struct Info: Codable {
        let page: Int
        let results: Int
        let seed: String?
        let version: String?
    }
}
