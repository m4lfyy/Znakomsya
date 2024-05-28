import Foundation
import UIKit

struct ProfileData: Hashable {
    
    var id: String = ""
    
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
    var photo: UIImage? = UIImage(named: "profphoto")
    var preferences_photo: UIImage?
    
    var photoUpdated: Bool = false
    var preferencesPhotoUpdated: Bool = false
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date_of_birth, to: Date())
        return ageComponents.year!
    }
    
    func profileImageArray() -> [UIImage?] {
        var images = [UIImage?]()
        
        // Добавить основное фото, если доступно
        if let mainPhoto = photo {
            images.append(mainPhoto)
        }
        
        // Загрузить дополнительные фото из каталога Assets
        let assetPhotoNames = ["test", "test1", "test2"] // Пример имен изображений в каталоге Assets
        for photoName in assetPhotoNames {
            if let image = UIImage(named: photoName) {
                images.append(image)
            }
        }
        
        return images
    }
    
    mutating func updateProfilePhoto(_ photo: UIImage) {
        self.photo = photo
        self.photoUpdated = true
    }
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

