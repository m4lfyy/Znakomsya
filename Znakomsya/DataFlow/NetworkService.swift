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
                        completion(.success(()))
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
    
    func getStateToken(completion: @escaping (Result<String, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/google/state_token") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.clientError))
                return
            }

            if let data = data, let stateToken = String(data: data, encoding: .utf8) {
                completion(.success(stateToken))
            } else {
                completion(.failure(.unknownServerError))
            }
        }.resume()
    }
    
    func sendAuthorizationCodeToServer(_ authorizationCode: String, state: String, completion: @escaping (Result<String, MyError>) -> Void) {
        // Создаем URL с параметрами
        var components = URLComponents(string: "http://localhost:8080/google/callback")
        components?.queryItems = [
            URLQueryItem(name: "code", value: authorizationCode),
            URLQueryItem(name: "state", value: state)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }

        // Создаем GET-запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.clientError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let data = data, let accessToken = String(data: data, encoding: .utf8) {
                        completion(.success(accessToken))
                    } else {
                        completion(.failure(.unknownServerError))
                    }
                default:
                    completion(.failure(.unknownServerError))
                }
            } else {
                completion(.failure(.unknownServerError))
            }
        }.resume()
    }
}
