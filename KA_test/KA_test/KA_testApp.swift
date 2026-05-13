//
//  KA_testApp.swift
//  KA_test
//
//  Created by Pavel Bondar on 11.05.26.
//

import SwiftUI

@main
struct KA_testApp: App {
    
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                UsersView()
            }
            .environmentObject(navigationManager)
        }
    }
}
