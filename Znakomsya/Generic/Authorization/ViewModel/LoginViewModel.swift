import SwiftUI
import Foundation

class LoginViewModel: ObservableObject {
    @Published var loginData = LoginData()
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var navigateToMainTab = false

    private let authService: AuthServiceProtocol
        private let googleService: GoogleServiceProtocol
        private let tokenManager: TokenManagerProtocol

        init(authService: AuthServiceProtocol = AuthService(config: ServiceConfiguration()),
             tokenManager: TokenManagerProtocol = TokenManager(),
             googleService: GoogleServiceProtocol = GoogleService(tokenService: TokenService(config: ServiceConfiguration()))) {
            self.authService = authService
            self.tokenManager = tokenManager
            self.googleService = googleService
        }

    func loginUser() {
        if let errorMessage = loginData.validationError() {
            self.alertMessage = errorMessage
            self.showAlert = true
            return
        }

        authService.loginUser(with: loginData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loginResponse):
                    self?.tokenManager.saveToken(loginResponse.access_token)
                    self?.navigateToMainTab = true
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
    
    func loginUserWithGoogle() {
        googleService.loginUserWithGoogle { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    self?.tokenManager.saveToken(accessToken)
                    self?.navigateToMainTab = true
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
    
    func checkExistingToken() {
        if let token = tokenManager.getToken(), !token.isEmpty {
            self.navigateToMainTab = true
        }
    }
    
    func logout() {
        tokenManager.deleteToken()
        self.navigateToMainTab = false
    }
}
