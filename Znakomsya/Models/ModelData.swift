import SwiftUI
import CoreData

class ModelData: ObservableObject {
    @Published var registrationData: RegistrationData = RegistrationData()
    
    func registerUser(completion: @escaping (Result<String, Error>) -> Void) {
        guard let jsonData = try? JSONEncoder().encode(registrationData) else {
            completion(.failure(MyError.encodingError))
            return
        }

        guard let url = URL(string: "http://your-server-url/register") else {
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
                    if let token = try? JSONDecoder().decode(Token.self, from: data) {
                        completion(.success(token.token))
                    } else {
                        completion(.failure(MyError.parsingError))
                    }
                } else {
                    completion(.failure(MyError.serverError))
                }
            }
        }.resume()
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
