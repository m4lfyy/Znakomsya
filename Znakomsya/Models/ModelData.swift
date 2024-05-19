import CoreData

class ModelData: ObservableObject {
    @Published var registrationData: RegistrationData = RegistrationData()
    @Published var loginData: LoginData = LoginData()
    
    static let shared = ModelData()
    
    // Сохранение данных регистрации временно
    var registrationResponse: RegistrationResponse?
    
    func saveDataToCoreData(successfulResponse: RegistrationResponse) {
        let managedContext = CoreDataStack.shared.managedContext

        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
            fatalError("Failed to retrieve User entity description")
        }
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)

        user.setValue(successfulResponse.id, forKey: "id")
        user.setValue(successfulResponse.name, forKey: "name")
        user.setValue(successfulResponse.sex, forKey: "sex")
        user.setValue(successfulResponse.date_of_birth, forKey: "date_of_birth")
        user.setValue(successfulResponse.email, forKey: "email")
        user.setValue(successfulResponse.phone_number, forKey: "phone_number")
        user.setValue(successfulResponse.registered_at, forKey: "registered_at")

        do {
            try managedContext.save()
            print("User data saved to Core Data successfully")
        } catch {
            fatalError("Failed to save user data to Core Data: \(error)")
        }
    }
    
    func registerUser(completion: @escaping (Result<Void, MyError>) -> Void) {
        NetworkService.shared.registerUser(with: registrationData) { result in
            switch result {
            case .success(let userResponse):
                self.registrationResponse = userResponse
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(completion: @escaping (Result<Void, MyError>) -> Void) {
        NetworkService.shared.loginUser(with: loginData) { result in
            switch result {
            case .success:
                if let userResponse = self.registrationResponse {
                    self.saveDataToCoreData(successfulResponse: userResponse)
                    completion(.success(()))
                } else {
                    completion(.failure(.unknownServerError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

