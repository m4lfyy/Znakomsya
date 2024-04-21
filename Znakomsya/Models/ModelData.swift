import SwiftUI
import CoreData

class ModelData: ObservableObject {
    @Published var registrationData: RegistrationData = RegistrationData()
    @Published var loginData: LoginData = LoginData()

    private func sendDataToServer<T: Encodable>(urlString: String, data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let jsonData = try? JSONEncoder().encode(data) else {
            completion(.failure(MyError.encodingError))
            return
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(MyError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if urlString == "http://your-server-url/register" {
                        if let token = try? JSONDecoder().decode(Token.self, from: data) {
                            TokenManager.shared.saveToken(token.token) // Сохранение токена при успешной регистрации
                            self.saveDataToCoreData(registrationData: self.registrationData) // Сохранение данных в CoreData
                            completion(.success(()))
                        } else {
                            completion(.failure(MyError.parsingError))
                        }
                    } else if urlString == "http://your-server-url/login" {
                        if let token = try? JSONDecoder().decode(Token.self, from: data) {
                            TokenManager.shared.saveToken(token.token) // Сохранение токена при успешной авторизации
                            completion(.success(()))
                        } else {
                            completion(.failure(MyError.parsingError))
                        }
                    }
                } else {
                    completion(.failure(MyError.serverError))
                }
            }
        }.resume()
    }

    func registerUser(completion: @escaping (Result<Void, Error>) -> Void) {
        sendDataToServer(urlString: "http://your-server-url/register", data: registrationData, completion: completion)
    }

    func loginUser(completion: @escaping (Result<Void, Error>) -> Void) {
        sendDataToServer(urlString: "http://your-server-url/login", data: loginData, completion: completion)
    }

    func saveDataToCoreData(registrationData: RegistrationData) {
        let managedContext = CoreDataStack.shared.managedContext

        // Создаем новый объект User в контексте управляемых объектов Core Data
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
            fatalError("Failed to retrieve User entity description")
        }
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)

        // Устанавливаем значения атрибутов объекта User из данных регистрации
        user.setValue(registrationData.name, forKey: "name")
        user.setValue(registrationData.gender, forKey: "gender")
        user.setValue(registrationData.birthDate, forKey: "birthDate")
        user.setValue(registrationData.email, forKey: "email")
        user.setValue(registrationData.phone, forKey: "phone")
        user.setValue(registrationData.password, forKey: "password")

        // Сохраняем изменения в контексте управляемых объектов Core Data
        do {
            try managedContext.save()
            print("User data saved to Core Data successfully")
        } catch {
            fatalError("Failed to save user data to Core Data: \(error)")
        }
    }

    struct Token: Codable {
        let token: String
    }

    enum MyError: Error {
        case encodingError
        case invalidURL
        case parsingError
        case serverError
    }
}
