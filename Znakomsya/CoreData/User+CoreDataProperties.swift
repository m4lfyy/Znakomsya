import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var birthDate: Date?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
