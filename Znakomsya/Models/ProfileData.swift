import Foundation
import UIKit

struct ProfileData {
    // RegistrationData fields
    var name: String = ""
    var sex: String = "М"
    var date_of_birth: Date = Date()
    var email: String = ""
    var phone_number: String = ""

    // ProfileData fields
    var location: String = ""
    var work: String = ""
    var music: String = ""
    var films: String = ""
    var sport: String = ""
    var hobby: String = ""
    var interest_sex: String = ""
    var preferences_text: String = ""
    var photo: UIImage? = UIImage(named: "defaultPhoto")
    var preferences_photo: UIImage?
    
    var photoUpdated: Bool = false
    var preferencesPhotoUpdated: Bool = false
    
}

struct ServerResponse: Decodable {
    let id: String
    let email: String
    let name: String
    let phone_number: String
    let sex: String
    let date_of_birth: String
    let work: String?
    let music: String?
    let location: String?
    let films: String?
    let sport: String?
    let hobby: String?
    let interest_sex: String?
    let preferences_text: String?
    let photo: String?
    let preferences_photo: String?
    let is_active: Bool
    let is_superuser: Bool
    let is_verified: Bool
}

struct StateResponse: Decodable {
    let state_token: String
}
