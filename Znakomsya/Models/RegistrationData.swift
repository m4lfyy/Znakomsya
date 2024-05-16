import SwiftUI

struct RegistrationData {
    var name: String = ""
    var sex: String = "М"
    var date_of_birth: Date = Date()
    var email: String = ""
    var phone_number: String = ""
    var password: String = ""
    
    // Функция для проверки всех введенных данных
    func validationError(check: String) -> String? {
        switch true {
        case name.isEmpty:
            return "Введите имя"
        case !validateBirthDate():
            return "Вы должны быть старше 16 лет для регистрации"
        case email.isEmpty:
            return "Введите адрес электронной почты"
        case !validateEmail():
            return "Введите корректный адрес электронной почты"
        case phone_number.isEmpty:
            return "Введите номер телефона"
        case !validatePhoneNumber():
            return "Введите корректный номер телефона"
        case password.isEmpty:
            return "Введите пароль"
        case check.isEmpty:
            return "Введите подтверждение пароля"
        case !validatePasswordMatch(check: check):
            return "Пароли не совпадают"
        default:
            return nil // Если все поля валидны, возвращаем nil
        }
    }
    
    // Функция для валидации даты
    private func validateBirthDate() -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let minBirthDate = calendar.date(byAdding: .year, value: -16, to: currentDate)!
        
        return date_of_birth <= minBirthDate
    }
    
    // Функция для валидации почты
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Функция для валидации номера телефона
    private func validatePhoneNumber() -> Bool {
        let phoneRegex = "^\\+7[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone_number)
    }
    
    // Функция для проверки совпадения паролей
    private func validatePasswordMatch(check: String) -> Bool {
        return password == check
    }
}

extension RegistrationData: Encodable {
    enum CodingKeys: String, CodingKey {
        case name, sex, date_of_birth, email, phone_number, password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(sex, forKey: .sex)
        try container.encode(date_of_birth, forKey: .date_of_birth)
        try container.encode(email, forKey: .email)
        try container.encode(phone_number, forKey: .phone_number)
        try container.encode(password, forKey: .password)
    }
}
