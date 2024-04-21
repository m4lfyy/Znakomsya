import SwiftUI

struct LoginData {
    var username: String = ""
    var password: String = ""

    // Функция для проверки введенных данных
    func validationError() -> String? {
        switch true {
        case username.isEmpty:
            return "Введите логин"
        case password.isEmpty:
            return "Введите пароль"
        default:
            return nil // Если все поля валидны, возвращаем nil
        }
    }
}

extension LoginData: Encodable {
    enum CodingKeys: String, CodingKey {
        case username, password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
    }
}

