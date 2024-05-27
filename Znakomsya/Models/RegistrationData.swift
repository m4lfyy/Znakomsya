import Foundation

struct RegistrationData: Encodable {
    var name: String = ""
    var sex: String = "М"
    var date_of_birth: Date = Date()
    var email: String = ""
    var phone_number: String = ""
    var password: String = ""
    
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
        case password.isEmpty:
            return "Введите пароль"
        case check.isEmpty:
            return "Введите подтверждение пароля"
        case !validatePasswordMatch(check: check):
            return "Пароли не совпадают"
        default:
            return nil
        }
    }
    
    private func validateBirthDate() -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let minBirthDate = calendar.date(byAdding: .year, value: -16, to: currentDate)!
        return date_of_birth <= minBirthDate
    }
    
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePasswordMatch(check: String) -> Bool {
        return password == check
    }
}
