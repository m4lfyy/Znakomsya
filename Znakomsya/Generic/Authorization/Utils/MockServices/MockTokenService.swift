import Foundation

class MockTokenService: TokenServiceProtocol {
    func getStateToken(completion: @escaping (Result<String, MyError>) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // Return a mock state token after delay
            completion(.success("mockStateToken"))
        }
    }

    func sendAuthorizationCodeToServer(_ authCode: String, state: String, completion: @escaping (Result<String, MyError>) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // Return a mock access token after delay
            completion(.success("mockAccessToken"))
        }
    }
}
