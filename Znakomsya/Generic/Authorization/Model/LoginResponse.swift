import Foundation

struct LoginResponse: Decodable {
    let access_token: String
    let token_type: String
}
