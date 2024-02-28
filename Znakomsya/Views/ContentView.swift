import SwiftUI

struct ContentView: View {
    @StateObject private var modelData = ModelData()
    
    var body: some View {
        NavigationView {
            WelcomeView()
                .environmentObject(modelData)
        }
    }
}


#Preview {
    ContentView()
}
