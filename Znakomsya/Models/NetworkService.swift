import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func registerUser(with registrationData: RegistrationData, completion: @escaping (Result<RegistrationResponse, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/register") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(registrationData) else {
            completion(.failure(.encodingError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.clientError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    do {
                        let decodedData = try JSONDecoder().decode(RegistrationResponse.self, from: data)
                        self.requestVerifyToken(for: registrationData.email) { result in
                            switch result {
                            case .success:
                                completion(.success(decodedData))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } catch {
                        completion(.failure(.parsingError))
                    }
                case 400:
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completion(.failure(.serverError(errorResponse.detail)))
                    } catch {
                        completion(.failure(.parsingError))
                    }
                default:
                    completion(.failure(.unknownServerError))
                }
            } else {
                completion(.failure(.unknownServerError))
            }
        }.resume()
    }
    
    func loginUser(with loginData: LoginData, completion: @escaping (Result<Void, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/login") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(loginData) else {
            completion(.failure(.encodingError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.clientError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let tokenResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        TokenManager.shared.saveToken(tokenResponse.access_token)
                        
                        // Использовать данные пользователя, сохраненные после регистрации
                        if let userResponse = ModelData.shared.registrationResponse {
                            ModelData.shared.saveDataToCoreData(successfulResponse: userResponse)
                            completion(.success(()))
                        } else {
                            completion(.failure(.unknownServerError))
                        }
                    } catch {
                        completion(.failure(.parsingError))
                    }
                case 400:
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completion(.failure(.serverError(errorResponse.detail)))
                    } catch {
                        completion(.failure(.parsingError))
                    }
                default:
                    completion(.failure(.unknownServerError))
                }
            } else {
                completion(.failure(.unknownServerError))
            }
        }.resume()
    }
    
    private func requestVerifyToken(for email: String, completion: @escaping (Result<Void, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/request_verify_token") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let requestBody: [String: String] = ["email": email]
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            completion(.failure(.encodingError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.clientError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 202:
                    completion(.success(()))
                default:
                    completion(.failure(.unknownServerError))
                }
            } else {
                completion(.failure(.unknownServerError))
            }
        }.resume()
    }
}
