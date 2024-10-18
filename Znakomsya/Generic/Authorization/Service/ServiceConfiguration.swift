import Foundation

struct ServiceConfiguration {
    let serverHost: String
    let urlSession: URLSession

    init(serverHost: String = "http://localhost:8080", urlSession: URLSession = .shared) {
        self.serverHost = serverHost
        self.urlSession = urlSession
    }
}

