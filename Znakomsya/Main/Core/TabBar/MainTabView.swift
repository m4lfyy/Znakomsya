//
//  MainTabView.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 23.05.2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CardStackView()
                .tabItem { Image(systemName: "flame") }
                .tag(0)
            
            CurrentUserProfileView(user: MockData.users[0])
                .tabItem { Image(systemName: "person") }
                .tag(1)
        }
        .tint(.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(MatchManager())
}
