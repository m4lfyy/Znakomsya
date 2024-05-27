import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func registerUser(with registrationData: RegistrationData, completion: @escaping (Result<Void, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/register") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(registrationData) else {
            completion(.failure(.encodError))
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
                    self.requestVerifyToken(for: registrationData.email) { result in
                        switch result {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
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
    
    func loginUser(with loginData: LoginData, completion: @escaping (Result<LoginResponse, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/login") else {
            completion(.failure(.invalidURL))
            return
        }

        // Создаем тело запроса в формате URL-encoded
        let parameters: [String: String] = [
            "grant_type": "",
            "username": loginData.username,
            "password": loginData.password,
            "scope": "",
            "client_id": "",
            "client_secret": ""
        ]
        
        let parameterArray = parameters.map { key, value in
            return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        let parameterString = parameterArray.joined(separator: "&")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameterString.data(using: .utf8)

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
                        completion(.success(tokenResponse))
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
        // Создаем параметры в формате URL-encoded
        let parameters: [String: String] = [
            "code": authorizationCode,
            "state": state
        ]
        
        let parameterArray = parameters.map { key, value in
            return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        let parameterString = parameterArray.joined(separator: "&")
        
        guard let url = URL(string: "http://localhost:8080/google/callback?\(parameterString)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Создаем GET-запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.clientError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let accessToken = String(data: data, encoding: .utf8) {
                        completion(.success(accessToken))
                    } else {
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

    
    func sendUpdatedProfile(updatedData: [String: Any], userEmail: String, completion: @escaping (Result<ServerResponse, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/profile/email/\(userEmail)") else {
            completion(.failure(.invalidURL))
            return
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: updatedData, options: []) else {
            completion(.failure(.encodError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                        completion(.success(serverResponse))
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
    
    func getProfile(userEmail: String, completion: @escaping (Result<ServerResponse, MyError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/profile/email/\(userEmail)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.clientError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                        completion(.success(serverResponse))
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
            completion(.failure(.encodError))
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
