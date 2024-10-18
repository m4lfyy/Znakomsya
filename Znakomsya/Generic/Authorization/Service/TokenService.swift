import Foundation

class TokenService: TokenServiceProtocol {
    private let config: ServiceConfiguration

    init(config: ServiceConfiguration) {
        self.config = config
    }
    
    func getStateToken(completion: @escaping (Result<String, MyError>) -> Void) {
        guard let url = URL(string: "\(config.serverHost)/google/state_token") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        config.urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.clientError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let stateResponse = try JSONDecoder().decode(StateResponse.self, from: data)
                        print(stateResponse.state_token)
                        completion(.success(stateResponse.state_token))
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

    func sendAuthorizationCodeToServer(_ authorizationCode: String, state: String, completion: @escaping (Result<String, MyError>) -> Void) {        
        guard let url = URL(string: "\(config.serverHost)/google/callback/\(authorizationCode)/\(state)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        config.urlSession.dataTask(with: request) { data, response, error in
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
}

