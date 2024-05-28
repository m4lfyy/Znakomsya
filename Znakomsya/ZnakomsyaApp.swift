import SwiftUI

@main
struct ZnakomsyaApp: App {
    @StateObject var matchManager = MatchManager()
    @StateObject var modelData = ModelData()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(matchManager)
        }
    }
}

