//
//  NavigationManager.swift
//  KA_test
//
//  Created by Pavel Bondar on 13.05.26.
//

import Foundation
import SwiftUI
import Combine

final class NavigationManager: ObservableObject {
    @Published var path = [AppRoute]()
}

enum AppRoute: Hashable {
    case userDetails(user: User)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .userDetails(let user):
            UserDetailView(user: user)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .userDetails(let user):
            hasher.combine(user.id)
        }
    }
    
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.userDetails(let lhsUser), .userDetails(let rhsUser)):
            return lhsUser.id == rhsUser.id
        }
    }
}
