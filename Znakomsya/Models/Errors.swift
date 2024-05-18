import Foundation

enum MyError: Error {
    case encodingError
    case invalidURL
    case parsingError
    case clientError
    case serverError(String)
    case unknownServerError
    
    var localizedDescription: String {
        switch self {
        case .encodingError:
            return "Ошибка при кодировании данных."
        case .invalidURL:
            return "Некорректный URL."
        case .parsingError:
            return "Ошибка при обработке данных."
        case .clientError:
            return "Ошибка на стороне клиента."
        case .serverError(let message):
            return "Ошибка: \(message)"
        case .unknownServerError:
            return "Неизвестная ошибка на стороне сервера."
        }
    }
}

struct ErrorResponse: Decodable {
    let detail: String
}

