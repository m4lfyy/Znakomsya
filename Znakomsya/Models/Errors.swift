import Foundation

enum MyError: Error {
    case encodError
    case invalidURL
    case parsingError
    case clientError
    case serverError(String)
    case unknownServerError
    case coreDataSaveError
    case coreDataFetchError
    
    var localizedDescription: String {
        switch self {
        case .encodError:
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
        case .coreDataSaveError:
            return "Не удалось обновить данные в CoreData"
        case .coreDataFetchError:
            return "Не удалось взять данные с CoreData"
        }
    }
}

struct ErrorResponse: Decodable {
    let detail: String
}

