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
    @NSManaged public var registered_at: String?

}

extension User : Identifiable {

}
