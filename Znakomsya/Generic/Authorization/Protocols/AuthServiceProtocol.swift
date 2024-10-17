import Foundation

protocol AuthServiceProtocol {
    func loginUser(with loginData: LoginData, completion: @escaping (Result<LoginResponse, MyError>) -> Void)
}
