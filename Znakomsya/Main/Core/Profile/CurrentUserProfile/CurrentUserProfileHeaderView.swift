//
//  CurrentUserProfileHeaderView.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 26.05.2024.
//

import SwiftUI

struct CurrentUserProfileHeaderView: View {
    let user: UserInfo
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(user.profileImageURLs[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .background {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 128, height: 128)
                            .shadow(radius: 10)
                    }
                
                Image(systemName: "pencil")
                    .imageScale(.small)
                    .foregroundStyle(.gray)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 32, height: 32)
                    }
                    .offset(x: -8, y: 10)
            }
            Text("\(user.fullname), ")
                .font(Font.custom("Montserrat-Bold", size: 22)) +
            Text("\(user.age)")
                .font(Font.custom("Montserrat-MediumItalic", size: 22))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
    }
}

#Preview {
    CurrentUserProfileHeaderView(user: MockData.users[0])
}
