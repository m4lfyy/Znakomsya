import Foundation
import KeychainSwift

class TokenManager {
    static let shared = TokenManager()
    private let keychain = KeychainSwift()

    private let tokenKey = "accessToken"

    func saveToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        return keychain.get(tokenKey)
    }

    func deleteToken() {
        keychain.delete(tokenKey)
    }
}
