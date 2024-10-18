import GoogleSignIn

class GoogleService: GoogleServiceProtocol {
    
    private let tokenService: TokenServiceProtocol
    
    init(tokenService: TokenServiceProtocol) {
        self.tokenService = tokenService
    }

    func loginUserWithGoogle(completion: @escaping (Result<String, MyError>) -> Void) {
        guard (GIDSignIn.sharedInstance.configuration?.clientID) != nil else {
            completion(.failure(.clientError))
            return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            completion(.failure(.clientError))
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if error != nil {
                completion(.failure(.clientError))
                return
            }

            guard let signInResult = signInResult,
                  let authorizationCode = signInResult.serverAuthCode else {
                completion(.failure(.clientError))
                return
            }

            self.tokenService.getStateToken { result in
                switch result {
                case .success(let stateToken):
                    self.tokenService.sendAuthorizationCodeToServer(authorizationCode, state: stateToken) { result in
                        switch result {
                        case .success(let accessToken):
                            completion(.success(accessToken))
                        case .failure(let error):
                            completion(.failure(.serverError(error.localizedDescription)))
                        }
                    }
                case .failure(let error):
                    completion(.failure(.serverError(error.localizedDescription)))
                }
            }
        }
    }
}
