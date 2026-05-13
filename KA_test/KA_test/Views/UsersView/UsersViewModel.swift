//
//  UsersViewModel.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//

import SwiftUI
import Combine


class UsersViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private var defaultSize = 10
    
    @UserDefaultsObjectWrapper(key: "seedValue", defaultValue: nil)
    private var seed: String?
    @UserDefaultsObjectWrapper(key: "versionValue", defaultValue: nil)
    private var version: String?
    
    private var page: Int = 0
    
    private lazy var size = defaultSize
    
    func fetchUsers(reload: Bool, isFirstAppear: Bool = false, pagination: Bool, appear: Bool = false, completion: @escaping (Bool) -> Void) {
        if reload {
            page = 0
            if !isFirstAppear {
                seed = nil
                version = nil
            }
            
            if appear {
                if users.isEmpty {
                    size = defaultSize
                } else {
                    size = users.count
                }
            } else {
                size = defaultSize
            }
        } else if pagination {
            page += 1
        }
        APIService().fetchUsers(page: page, size: size, seed: seed, version: version)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                switch value {
                case .success(let result):
                    self?.page = result.info.page
                    self?.seed = result.info.seed
                    self?.version = result.info.version
                    
                    if pagination { self?.users += result.results }
                    else { self?.users = result.results }
                    completion(true)
                case .failure:
                    completion(false)
                }
            })
            .store(in: &cancellables)
    }
}
