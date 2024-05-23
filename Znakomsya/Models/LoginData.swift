import Foundation

struct LoginData: Encodable {
    var username: String = ""
    var password: String = ""
    
    func validationError() -> String? {
        switch true {
        case username.isEmpty:
            return "Введите почту"
        case password.isEmpty:
            return "Введите пароль"
        default:
            return nil
        }
    }
    
    mutating func reset() {
        username = ""
        password = ""
    }
}

struct LoginResponse: Decodable {
    let access_token: String
    let token_type: String
}
