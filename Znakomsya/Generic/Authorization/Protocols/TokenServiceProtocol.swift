import Foundation

protocol TokenServiceProtocol {
    func getStateToken(completion: @escaping (Result<String, MyError>) -> Void)
    func sendAuthorizationCodeToServer(_ authCode: String, state: String, completion: @escaping (Result<String, MyError>) -> Void)
}
