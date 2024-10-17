import Foundation

class MockAuthService: AuthServiceProtocol {
    func loginUser(with loginData: LoginData, completion: @escaping (Result<LoginResponse, MyError>) -> Void) {
        // Simulate a network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Mock validation logic
            if loginData.username == "test@example.com" && loginData.password == "password" {
                // Simulate a successful login response
                let mockResponse = LoginResponse(access_token: "mock_access_token", token_type: "Bearer")
                completion(.success(mockResponse))
            } else {
                // Simulate a failure response
                completion(.failure(.serverError("Invalid credentials")))
            }
        }
    }
}
