import CoreData
import GoogleSignIn

class ModelData: ObservableObject {
    
    static let shared = ModelData()
    
    @Published var registrationData: RegistrationData = RegistrationData()
    @Published var loginData: LoginData = LoginData()
    @Published var profileData: ProfileData = ProfileData()
    
    
    // Сохранение данных регистрации временно
    private var serverResponse: ServerResponse?
    
    func registerUser(completion: @escaping (Result<Void, MyError>) -> Void) {
        NetworkService.shared.registerUser(with: registrationData) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(completion: @escaping (Result<Void, MyError>) -> Void) {
        NetworkService.shared.loginUser(with: loginData) { result in
            switch result {
            case .success(let tokenResponse):
                TokenManager.shared.saveToken(tokenResponse.access_token)
                let managedContext = CoreDataStack.shared.managedContext
                let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
                
                do {
                    let users = try managedContext.fetch(fetchRequest)
                    if users.isEmpty {
                        NetworkService.shared.getProfile(userEmail: self.loginData.username) { result in
                            switch result {
                            case .success(let userResponse):
                                self.serverResponse = userResponse
                                self.registrationDataToCoreData(successfulResponse: userResponse)
                                completion(.success(()))
                            case .failure(let error):
                                print("Get profile error: \(error)")
                                completion(.failure(error))
                            }
                        }
                    } else {
                        completion(.success(()))
                    }
                } catch {
                    completion(.failure(.coreDataFetchError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func signInWithGoogle() {
        guard let clientID = GIDSignIn.sharedInstance.configuration?.clientID else { return }
        let _ = GIDConfiguration(clientID: clientID, serverClientID: "331638865125-t9vf96bv08pr9viripqgeolikg8j2s1u.apps.googleusercontent.com")

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Unable to access root view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("Sign in failed: \(error)")
                return
            }

            guard let signInResult = signInResult else { return }
            print("Sign in succeeded: \(signInResult.user.profile?.name ?? "No name")")

            guard let authorizationCode = signInResult.serverAuthCode else {
                print("Failed to get authorization code")
                return
            }
            
            NetworkService.shared.getStateToken { result in
                switch result {
                case .success(let stateToken):
                    print(stateToken)
                    NetworkService.shared.sendAuthorizationCodeToServer(authorizationCode, state: stateToken) { result in
                        switch result {
                        case .success(let accessToken):
                            print("Access token received successfully")
                            TokenManager.shared.saveToken(accessToken)
                            self.initializeEmptyUserData()
                        case .failure(let error):
                            print("Failed to send authorization code: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Failed to get state token: \(error)")
                }
            }
        }
    }
    
    func sendUpdatedProfile(completion: @escaping (Result<Void, MyError>) -> Void) {
        let updatedData = compareAndGenerateUpdateDictionary(currentProfileData: profileData)
        NetworkService.shared.sendUpdatedProfile(updatedData: updatedData, userEmail: profileData.email) { result in
            switch result {
            case .success(let serverResponse):
                // Сохранение обновленных данных в CoreData
                self.updateCoreDataWithServerResponse(serverResponse)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func compareAndGenerateUpdateDictionary(currentProfileData: ProfileData) -> [String: Any] {
        let managedContext = CoreDataStack.shared.managedContext
        
        // Запрос на извлечение текущего пользователя из Core Data
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
            if let user = try managedContext.fetch(fetchRequest).first {
                var updateDictionary = [String: Any]()
                
                if currentProfileData.name != (user.value(forKey: "name") as? String ?? "") {
                    updateDictionary["name"] = currentProfileData.name
                }
                if currentProfileData.sex != (user.value(forKey: "sex") as? String ?? "") {
                    updateDictionary["sex"] = currentProfileData.sex
                }
                let currentDateOfBirthString = dateFormatter.string(from: currentProfileData.date_of_birth)
                if currentDateOfBirthString != (user.value(forKey: "date_of_birth") as? String ?? "") {
                    updateDictionary["date_of_birth"] = currentDateOfBirthString
                }
                if currentProfileData.email != (user.value(forKey: "email") as? String ?? "") {
                    updateDictionary["email"] = currentProfileData.email
                }
                if currentProfileData.phone_number != (user.value(forKey: "phone_number") as? String ?? "") {
                    updateDictionary["phone_number"] = currentProfileData.phone_number
                }
                
                if currentProfileData.location != (user.value(forKey: "location") as? String ?? "") {
                    updateDictionary["location"] = currentProfileData.location
                }
                if currentProfileData.work != (user.value(forKey: "work") as? String ?? "") {
                    updateDictionary["work"] = currentProfileData.work
                }
                if currentProfileData.music != (user.value(forKey: "music") as? String ?? "") {
                    updateDictionary["music"] = currentProfileData.music
                }
                if currentProfileData.films != (user.value(forKey: "films") as? String ?? "") {
                    updateDictionary["films"] = currentProfileData.films
                }
                if currentProfileData.sport != (user.value(forKey: "sport") as? String ?? "") {
                    updateDictionary["sport"] = currentProfileData.sport
                }
                if currentProfileData.hobby != (user.value(forKey: "hobby") as? String ?? "") {
                    updateDictionary["hobby"] = currentProfileData.hobby
                }
                if currentProfileData.interest_sex != (user.value(forKey: "interest_sex") as? String ?? "") {
                    updateDictionary["interest_sex"] = currentProfileData.interest_sex
                }
                if currentProfileData.preferences_text != (user.value(forKey: "preferences_text") as? String ?? "") {
                    updateDictionary["preferences_text"] = currentProfileData.preferences_text
                }
                
                if currentProfileData.photoUpdated {
                    if let imageData = currentProfileData.photo?.jpegData(compressionQuality: 0.8) {
                        let base64String = imageData.base64EncodedString()
                        updateDictionary["photo"] = base64String
                    }
                }
                
                if currentProfileData.preferencesPhotoUpdated {
                    if let preferencesPhoto = currentProfileData.preferences_photo,
                       let imageData = preferencesPhoto.jpegData(compressionQuality: 0.8) {
                        let base64String = imageData.base64EncodedString()
                        updateDictionary["preferencesPhoto"] = base64String
                    }
                }
                return updateDictionary
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
        
        return [:]
    }
    
    private func registrationDataToCoreData(successfulResponse: ServerResponse) {
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
        user.setValue(successfulResponse.work ?? "", forKey: "work")
        user.setValue(successfulResponse.location ?? "", forKey: "location")
        user.setValue(successfulResponse.music ?? "", forKey: "music")
        user.setValue(successfulResponse.films ?? "", forKey: "films")
        user.setValue(successfulResponse.sport ?? "", forKey: "sport")
        user.setValue(successfulResponse.hobby ?? "", forKey: "hobby")
        user.setValue(successfulResponse.interest_sex ?? "", forKey: "interest_sex")
        user.setValue(successfulResponse.preferences_text ?? "", forKey: "preferences_text")
        user.setValue(successfulResponse.photo ?? "", forKey: "photo")
        user.setValue(successfulResponse.preferences_photo ?? "", forKey: "preferences_photo")

        do {
            try managedContext.save()
            print("User data saved to Core Data successfully")
        } catch {
            fatalError("Failed to save user data to Core Data: \(error)")
        }
    }
    
    private func updateCoreDataWithServerResponse(_ response: ServerResponse) {
        let managedContext = CoreDataStack.shared.managedContext
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
        
        do {
            if let user = try managedContext.fetch(fetchRequest).first {
                user.setValue(response.id, forKey: "id")
                user.setValue(response.name, forKey: "name")
                user.setValue(response.sex, forKey: "sex")
                user.setValue(response.date_of_birth, forKey: "date_of_birth")
                user.setValue(response.email, forKey: "email")
                user.setValue(response.phone_number, forKey: "phone_number")
                
                user.setValue(response.work ?? "", forKey: "work")
                user.setValue(response.music ?? "", forKey: "music")
                user.setValue(response.films ?? "", forKey: "films")
                user.setValue(response.sport ?? "", forKey: "sport")
                user.setValue(response.hobby ?? "", forKey: "hobby")
                user.setValue(response.interest_sex ?? "", forKey: "interest_sex")
                user.setValue(response.preferences_text ?? "", forKey: "preferences_text")
                user.setValue(response.photo ?? "", forKey: "photo")
                user.setValue(response.preferences_photo ?? "", forKey: "preferences_photo")
                
                try managedContext.save()
            }
        } catch {
            print("Failed to update Core Data: \(error)")
        }
    }
    
    private func initializeEmptyUserData() {
        let managedContext = CoreDataStack.shared.managedContext

        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
            fatalError("Failed to retrieve User entity description")
        }

        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        user.setValue(UUID().uuidString, forKey: "id")
        user.setValue("", forKey: "name")
        user.setValue("", forKey: "sex")
        user.setValue("", forKey: "date_of_birth")
        user.setValue("", forKey: "email")
        user.setValue("", forKey: "phone_number")
        
        user.setValue("", forKey: "location")
        user.setValue("", forKey: "work")
        user.setValue("", forKey: "music")
        user.setValue("", forKey: "films")
        user.setValue("", forKey: "sport")
        user.setValue("", forKey: "hobby")
        user.setValue("", forKey: "interest_sex")
        user.setValue("", forKey: "preferences_text")
        user.setValue("", forKey: "photo")
        user.setValue("", forKey: "preferences_photo")

        do {
            try managedContext.save()
            print("Empty user data initialized in Core Data successfully")
        } catch {
            fatalError("Failed to save empty user data to Core Data: \(error)")
        }
    }

}
