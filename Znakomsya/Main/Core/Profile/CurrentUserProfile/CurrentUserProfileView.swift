//
//  CurrentUserProfileView.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 26.05.2024.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @State private var showEditProfile = false
    let user: UserInfo
    
    var body: some View {
        NavigationStack {
            List {
                // header view
                CurrentUserProfileHeaderView(user: user)
                    .onTapGesture {
                        showEditProfile.toggle()
                    }
                
                // account info
                Section("Account Info") {
                    HStack {
                        Text("Name")
                        
                        Spacer()
                        
                        Text(user.fullname)
                    }
                    
                    HStack {
                        Text("Email")
                        
                        Spacer()
                        
                        Text("test@gmail.com")
                    }
                }
                
                // legal
                Section("Legal") {
                    Text("Terms of Service")
                }
                
                // logout/delete
                Section {
                    Button ("Logout"){
                        print("DEBUG: Logout here..")
                    }
                    .foregroundStyle(.red)
                }
                    
                Section {
                    Button ("Delete account"){
                        print("DEBUG: Delete account..")
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showEditProfile) {
                EditProfileView(user: user)
            }
        }
    }
}

#Preview {
    CurrentUserProfileView(user: MockData.users[1])
}
