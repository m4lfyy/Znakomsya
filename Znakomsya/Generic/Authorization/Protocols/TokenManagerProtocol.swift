import Foundation

protocol TokenManagerProtocol {
    func saveToken(_ token: String)
    func getToken() -> String?
    func deleteToken()
}
