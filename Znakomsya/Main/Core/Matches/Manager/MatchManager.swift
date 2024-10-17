import Foundation

@MainActor
class MatchManager: ObservableObject {
    @Published var matchedUser: UserInfo?
    
    func checkForMatch(withUser user: UserInfo) {
        let didMatch = Bool.random()
        
        if didMatch {
            matchedUser = user
        }
    }
}
