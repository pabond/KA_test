//
//  UserBasicInfoView.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//

import SwiftUI
import Kingfisher

struct UserBasicInfoView: View {
    
    let user: User
    let textColor: Color
    
    @State var isImageLoaded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                if let imageLink = user.picture?.thumbnail {
                    KFImage(URL(string: imageLink))
                        .placeholder { _ in
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        .onSuccess{ _ in
                            isImageLoaded = true
                        }
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedCorner(radius: 8))
                        .background(.white)
                        .cornerRadius(8)
                        .shadow(color: isImageLoaded ? .init(uiColor: .init(red: 145/255, green: 158/255, blue: 171/255, alpha: 0.2)) : .clear, radius: 2, x: 0, y: 1)
                }
                Text(user.fullName)
                    .font(.headline)
                    .foregroundStyle(textColor)
                Spacer()
            }
            
            if let email = user.email {
                Text(email)
                    .foregroundStyle(textColor)
            }
        }
    }
    
    struct RoundedCorner: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
}
