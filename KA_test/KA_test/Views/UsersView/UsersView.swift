//
//  UsersView.swift
//  KA_test
//
//  Created by Pavel Bondar on 11.05.26.
//

import SwiftUI

struct UsersView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel = UsersViewModel()
    
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack(spacing: 0) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(CGSize(width: 1.5, height: 1.5))
                        .padding()
                        .padding(.top, 8)
                } else {
                    
                    ScrollView(.vertical) {
                        
                        LazyVStack(spacing: 12, content: {
                            ForEach($viewModel.users) { user in
                                Button(action: {
                                    navigationManager.path.append(.userDetails(user: user.wrappedValue))
                                }, label: {
                                    UserCell(user: user.wrappedValue)
                                }).padding(.horizontal, 20)
                                    .onAppear {
                                        if user.id == viewModel.users.last?.id {
                                            viewModel.fetchUsers(reload: false, pagination: true)
                                            { _ in }
                                        }
                                    }
                            }
                        })
                        .padding(.vertical, 20)
                    }
                    .refreshable {
                        viewModel.fetchUsers(reload: true, pagination: false, completion: { _ in })
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { type in
                type.destination
            }
        }
        .onAppear {
            viewModel.fetchUsers(reload: true, isFirstAppear: true, pagination: false, completion: { _ in
                self.isLoading = false
            })
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .top)
    }
}

#Preview {
    UsersView()
}
