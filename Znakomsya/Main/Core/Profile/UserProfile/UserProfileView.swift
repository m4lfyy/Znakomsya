//
//  UserProfileView.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 26.05.2024.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentImageIndex = 0
    
    let user: UserInfo
    
    var body: some View {
        VStack {
            HStack {
                Text(user.fullname)
                    .font(Font.custom("Montserrat-Bold", size: 24))
                
                Text("\(user.age)")
                    .font(Font.custom("Montserrat-MediumItalic", size: 24))
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.down.circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundStyle(.pink)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        Image(user.profileImageURLs[currentImageIndex])
                                .resizable()
                                .scaledToFill()
                                .frame(width: SizeConst.cardWidth, height: SizeConst.cardHeight)
                                .overlay {
                                    ImageScrollingOverlay(
                                        currentImageIndex: $currentImageIndex,
                                        imageCount: user.profileImageURLs.count
                                    )
                                }
                        CardImageIndicatorView(
                            currentImageIndex: currentImageIndex,
                            imageCount: user.profileImageURLs.count
                        )
                    }
                    
                    VStack (alignment: .leading, spacing: 12){
                        Text("About me")
                            .font(Font.custom("Montserrat-SemiBold", size: 16))
                        
                        Text("Some test bio for now..")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .font(Font.custom("Montserrat-Medium", size: 15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Essentials")
                        .font(Font.custom("Montserrat-SemiBold", size: 16))
                    
                    HStack {
                        Image(systemName: "person")
                        
                        Text("Man")
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "book")
                        
                        Text("Student")
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .font(Font.custom("Montserrat-Medium", size: 15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    UserProfileView(user: MockData.users[0])
}
