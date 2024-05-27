import UIKit
import GoogleSignIn

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Инициализация Google Sign-In
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: "331638865125-b8ojlm6thkasfdkecicn3bcm6aoletlf.apps.googleusercontent.com",
                                                                  serverClientID: "331638865125-t9vf96bv08pr9viripqgeolikg8j2s1u.apps.googleusercontent.com")
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

