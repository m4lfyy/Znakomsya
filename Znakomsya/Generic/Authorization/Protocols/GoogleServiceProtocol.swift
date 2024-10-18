import Foundation

protocol GoogleServiceProtocol {
    func loginUserWithGoogle(completion: @escaping (Result<String, MyError>) -> Void)
}

