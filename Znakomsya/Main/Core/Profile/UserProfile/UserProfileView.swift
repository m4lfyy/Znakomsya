//
//  UserProfileView.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 26.05.2024.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    @State private var currentImageIndex = 0
    
    var body: some View {
        VStack {
            HStack {
                Text(modelData.profileData.name)
                    .font(Font.custom("Montserrat-Bold", size: 24))
                
                Text("\(modelData.profileData.age)")
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
                        let imageArray = modelData.profileData.profileImageArray()
                        if let uiImage = imageArray[currentImageIndex] {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: SizeConst.cardWidth, height: SizeConst.cardHeight)
                                .overlay {
                                    ImageScrollingOverlay(
                                        currentImageIndex: $currentImageIndex,
                                        imageCount: imageArray.count
                                    )
                                }
                            CardImageIndicatorView(
                                currentImageIndex: currentImageIndex,
                                imageCount: imageArray.count
                            )
                        }
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
    UserProfileView().environmentObject(ModelData())
}
