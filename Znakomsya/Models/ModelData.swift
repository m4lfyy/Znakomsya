import SwiftUI
import CoreData

class ModelData: ObservableObject {
    @Published var registrationData: RegistrationData = RegistrationData()
    @Published var loginData: LoginData = LoginData()
    
    private func saveDataToCoreData(registrationResponse: RegistrationResponse) {
        let managedContext = CoreDataStack.shared.managedContext

        // Создаем новый объект User в контексте управляемых объектов Core Data
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
            fatalError("Failed to retrieve User entity description")
        }
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)

        // Устанавливаем значения атрибутов объекта User из данных успешного ответа сервера
        user.setValue(registrationResponse.id, forKey: "id")
        user.setValue(registrationResponse.name, forKey: "name")
        user.setValue(registrationResponse.sex, forKey: "sex")
        user.setValue(registrationResponse.date_of_birth, forKey: "date_of_birth")
        user.setValue(registrationResponse.email, forKey: "email")
        user.setValue(registrationResponse.phone_number, forKey: "phone_number")
        user.setValue(registrationResponse.registered_at, forKey: "registered_at")

        // Сохраняем изменения в контексте управляемых объектов Core Data
        do {
            try managedContext.save()
            print("User data saved to Core Data successfully")
        } catch {
            fatalError("Failed to save user data to Core Data: \(error)")
        }
    }
    
    func registerUser(completion: @escaping (Result<Void, Error>) -> Void) {
            // Подготовка данных для отправки
            guard let jsonData = try? JSONEncoder().encode(registrationData) else {
                completion(.failure(MyError.encodingError))
                return
            }
            
            // Создание URL для запроса
            guard let url = URL(string: "http://localhost:8080/register") else {
                completion(.failure(MyError.invalidURL))
                return
            }
            
            // Создание запроса
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Отправка запроса
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Проверяем наличие данных и ошибок
                guard let data = data, error == nil else {
                    completion(.failure(error ?? MyError.clientError))
                    return
                }
                
                // Обработка успешного ответа
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    if let decodedData = try? JSONDecoder().decode(RegistrationResponse.self, from: data) {
                        // Сохранение данных в Core Data
                        self.saveDataToCoreData(registrationResponse: decodedData)
                        completion(.success(()))
                    } else {
                        completion(.failure(MyError.parsingError))
                    }
                } else {
                    completion(.failure(MyError.serverError))
                }
            }.resume()
        }
    
    func loginUser(completion: @escaping (Result<Void, Error>) -> Void) {
            // Проверяем валидность данных
            guard let jsonData = try? JSONEncoder().encode(loginData) else {
                completion(.failure(MyError.encodingError))
                return
            }

            // Устанавливаем URL для запроса
            guard let url = URL(string: "http://localhost:8080/login") else {
                completion(.failure(MyError.invalidURL))
                return
            }

            // Создаем запрос
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            // Отправляем запрос
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Проверяем наличие данных и ошибок
                guard let data = data, error == nil else {
                    completion(.failure(error ?? MyError.clientError))
                    return
                }

                // Обработка успешного ответа
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        // Декодируем данные ответа
                        let tokenResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        TokenManager.shared.saveToken(tokenResponse.access_token)
                        // Возвращаем токен доступа
                        completion(.success(()))
                    } catch {
                        // Ошибка при декодировании данных
                        completion(.failure(MyError.parsingError))
                    }
                } else {
                    // Ошибка сервера
                    completion(.failure(MyError.serverError))
                }
            }.resume()
        }
    
    struct RegistrationResponse: Codable {
        let id: String
        let email: String
        let name: String
        let phone_number: String
        let sex: String
        let date_of_birth: String
        let registered_at: String
    }

    struct LoginResponse: Codable {
        let access_token: String
        let token_type: String
    }

    enum MyError: Error {
         case encodingError
         case invalidURL
         case parsingError
         case clientError
         case serverError
     }
    
}
