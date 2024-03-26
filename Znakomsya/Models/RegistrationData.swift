import SwiftUI

struct RegistrationData {
    var name: String = ""
    var gender: String = "М"
    var birthDate: Date = Date()
    var email: String = ""
    var phone: String = ""
    var password: String = ""
    
    func validationError() -> String? {
        if !isValidAge() {
            return "Пользователь должен быть не младше 16 лет"
        }

        if !isValidPhoneNumber() {
            return "Неверный номер телефона"
        }

        if !isValidEmail() {
            return "Неверный адрес электронной почты"
        }

        if name.isEmpty {
            return "Имя пользователя должно быть заполнено"
        }

        return nil
    }

    private func isValidAge() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        if let age = calendar.dateComponents([.year], from: birthDate, to: currentDate).year {
            return age >= 16
        }
        return false
    }

    private func isValidPhoneNumber() -> Bool {
        let phoneRegex = "^\\+7\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phone)
    }

    private func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}

extension RegistrationData: Encodable {
    enum CodingKeys: String, CodingKey {
        case name, gender, birthDate, email, phone, password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(gender, forKey: .gender)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(password, forKey: .password)
    }
}
