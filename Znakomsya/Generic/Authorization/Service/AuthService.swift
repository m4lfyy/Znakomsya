import Foundation

class AuthService: AuthServiceProtocol {
    private let serverHost: String
    private let urlSession: URLSession

    init(serverHost: String = "http://localhost:8080", urlSession: URLSession = .shared) {
        self.serverHost = serverHost
        self.urlSession = urlSession
    }

    func loginUser(with loginData: LoginData, completion: @escaping (Result<LoginResponse, MyError>) -> Void) {
        guard let url = URL(string: "\(serverHost)/login") else {
            completion(.failure(.invalidURL))
            return
        }

        let parameters: [String: String] = [
            "grant_type": "",
            "username": loginData.username,
            "password": loginData.password,
            "scope": "",
            "client_id": "",
            "client_secret": ""
        ]

        let parameterArray = parameters.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        let parameterString = parameterArray.joined(separator: "&")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameterString.data(using: .utf8)

        urlSession.dataTask(with: request) { data, response, error in
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
}
