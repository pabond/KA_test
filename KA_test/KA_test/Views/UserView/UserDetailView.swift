//
//  UserDetailView.swift
//  KA_test
//
//  Created by Pavel Bondar on 11.05.26.
//

import SwiftUI

struct UserDetailView: View {
    
    let user: User
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                UserBasicInfoView(user: user, textColor: .black)
                
                if let gender = user.gender {
                    Text("Gender: \(gender)")
                        .foregroundStyle(.black)
                }
                
                Text("User location: \(user.locationInfo)")
                    .foregroundStyle(.black)
                
                Text("Registered date: \(user.registerionDate)")
                    .foregroundStyle(.black)
                
                Spacer()
            }
            .padding()
        }
    }
    
}
