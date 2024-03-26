import SwiftUI

struct ContentView: View {
    @StateObject private var modelData = ModelData()
    
    var body: some View {
        NavigationView {
            RegistrationView()
                .environmentObject(modelData)
        }
    }
}


#Preview {
    ContentView()
}
