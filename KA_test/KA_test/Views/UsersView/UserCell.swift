//
//  UserCell.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//

import SwiftUI

struct UserCell: View {
    
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            UserBasicInfoView(user: user, textColor: .white)
            if let phone = user.phone, !phone.isEmpty {
                Text("Phone: \(phone)")
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .background(.gray.opacity(0.5))
        .shadow(color: .black.opacity(0.4), radius: 8, x: 4, y: 4)
        .cornerRadius(8)
    }
}
