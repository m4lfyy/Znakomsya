import SwiftUI

struct ContentView: View {
    @StateObject private var modelData = ModelData()
    
    var body: some View {
        NavigationView {
            AuthorizationView()
                .environmentObject(modelData)
                .preferredColorScheme(.light)
        }
    }
}


#Preview {
    ContentView()
}
