import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var date_of_birth: String?
    @NSManaged public var email: String?
    @NSManaged public var phone_number: String?
    @NSManaged public var id: String?
    @NSManaged public var location: String?
    @NSManaged public var work: String?
    @NSManaged public var music: String?
    @NSManaged public var films: String?
    @NSManaged public var sport: String?
    @NSManaged public var hobby: String?
    @NSManaged public var interest_sex: String?
    @NSManaged public var preferences_text: String?
    @NSManaged public var photo: String?
    @NSManaged public var preferences_photo: String?
}

extension User : Identifiable {

}
