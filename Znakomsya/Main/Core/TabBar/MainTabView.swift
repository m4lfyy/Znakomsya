import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        TabView {
            CardStackView()
                .tabItem { Image(systemName: "flame") }
                .tag(0)
            
            CurrentUserProfileView().environmentObject(modelData)
                .tabItem { Image(systemName: "person") }
                .tag(1)
        }
        .tint(.primary)
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    MainTabView()
        .environmentObject(MatchManager())
        .environmentObject(ModelData())
}
